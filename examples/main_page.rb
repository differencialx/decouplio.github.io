require_relative '../../decouplio/lib/decouplio'

class MyAction < Decouplio::Action
  logic do
    step :hello_world
  end

  def hello_world
    ctx[:result] = 'Hello world'
  end
end

MyAction.call[:result]



class CtxIntroduction < Decouplio::Action
  logic do
    step :calculate_result
  end

  def calculate_result
    ctx[:result] = c.one + c.two
    # OR
    # c[:result] = c[:one] + c[:two]
    #OR
    # ctx[:result] = ctx[:one] + ctx[:two]
  end
end

action_result = CtxIntroduction.call(one: 1, two: 2)

action_result[:result] # => 3


class Divider < Decouplio::Action
  logic do
    step :validate_divider
    step :divide
    fail :failure_message
  end

  def validate_divider
    !ctx[:divider].zero?
  end

  def divide
    ctx[:result] = c.number / c.divider
  end

  def failure_message
    ctx[:error_message] = 'Division by zero is not allowed'
  end
end

divider_success = Divider.call(number: 4, divider: 2)
divider_success.success? # => true
divider_success.failure? # => false
divider_success[:result] # => 2
divider_success[:error_message] # => nil
divider_success.railway_flow # => [:validate_divider, :divide]
divider_success # =>
# Result: success

# RailwayFlow:
#   validate_divider -> divide

# Context:
#   :number => 4
#   :divider => 2
#   :result => 2

# Status: NONE

# Errors:
#   NONE

divider_failure = Divider.call(number: 4, divider: 0)
divider_failure.success? #=> false
divider_failure.failure? #=> true
divider_failure[:result] # => nil
divider_failure[:error_message] # => 'Division by zero is not allowed'
divider_failure.railway_flow# => [:validate_divider, :failure_message]
divider_failure # =>
# Result: failure

# RailwayFlow:
#   validate_divider -> failure_message

# Context:
#   :number => 4
#   :divider => 0
#   :error_message => "Division by zero is not allowed"

# Status: NONE

# Errors:
#   NONE



class RailwayAction < Decouplio::Action
  logic do
    step :step1
    step :step2
    step :step3
  end

  def step1
    ctx[:step1] = 'Step1'
  end

  def step2
    ctx[:step2] = 'Step2'
  end

  def step3
    ctx[:step3] = 'Step3'
  end
end

railway_action = RailwayAction.call
railway_action.railway_flow.inspect # => [:step1, :step2, :step3]

railway_action # =>
# Result: success

# RailwayFlow:
#   step1 -> step2 -> step3

# Context:
#   :step1 => "Step1"
#   :step2 => "Step2"
#   :step3 => "Step3"

# Status: NONE

# Errors:
#   NONE



class MetaStoreAction < Decouplio::Action
  logic do
    step :always_fails
    fail :handle_fail
  end

  # Decouplio has to constants which are accessible inside steps
  # PASS = true
  # FAIL = false
  # You can use then to force step to fail or pass

  def always_fails
    FAIL
  end

  def handle_fail
    ms.status = :failed_and_i_duno_why
    ms.add_error(:something_went_wrong, 'Something went wrong')
    ms.add_error(:something_went_wrong, 'And I duno why :(')
  end
end

puts MetaStoreAction.call #=>
# Result: failure
# RailwayFlow:
#   always_fails -> handle_fail
# Context:
#   Empty
# Status: :failed_and_i_duno_why
# Errors:
#   :something_went_wrong => ["Something went wrong", "And I duno why :("]
