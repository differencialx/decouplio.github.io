require 'decouplio'

class ProcessNumber < Decouplio::Action
  logic do
    step :multiply
    step :divide
  end

  def multiply
    ctx[:result] = ctx[:number] * ctx[:multiplier]
  end

  def divide
    ctx[:result] = c.result / c.divider
  end
end

action = ProcessNumber.call(number: 5, multiplier: 4, divider: 10) # =>

action
# Result: success

# RailwayFlow:
#   multiply -> divide

# Context:
#   :number => 5
#   :multiplier => 4
#   :divider => 10
#   :result => 2

# Status: NONE

# Errors:
#   NONE
action[:number]# => 5
action[:multiplier]# => 4
action[:divider]# => 10
action[:result]# => 2

action.success? # => true
action.failure? # => false

action.railway_flow.to_s # => [:multiply, :divide]


# OR
# If action result is failure then Decouplio::Errors::ExecutionError is raised
class RaisingAction < Decouplio::Action
  logic do
    step :step_one
    step :step_two
  end

  def step_one
    ctx[:step_one] = c.step_one_param
  end

  def step_two
    ctx[:step_two] = 'Success'
  end
end

begin
  RaisingAction.call!(step_one_param: false)
rescue Decouplio::Errors::ExecutionError => exception
  puts exception.message # => Action failed.
  puts exception.action # =>
  # Result: failure

  # RailwayFlow:
  #   step_one

  # Context:
  #   :step_one_param => false
  #   :step_one => false

  # Status: NONE

  # Errors:
  #   NONE

end
