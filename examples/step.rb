require 'decouplio'



# Behavior
class SomeAction < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one
    step :step_two
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(**)
    ctx[:action_failed] = true
  end

  def step_two(**)
    ctx[:result] = 'Success'
  end
end

success_action = SomeAction.call(param_for_step_one: true)
failure_action = SomeAction.call(param_for_step_one: false)

success_action # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two

# Context:
#   :param_for_step_one => true
#   :result => "Success"

# Status: NONE

# Errors:
#   NONE

failure_action # =>
# Result: failure

# RailwayFlow:
#   step_one -> fail_one

# Context:
#   :param_for_step_one => false
#   :action_failed => true

# Status: NONE

# Errors:
#   NONE



# on_success: :finish_him
class SomeActionOnSuccessFinishHim < Decouplio::Action
  logic do
    step :step_one, on_success: :finish_him
    fail :fail_one
    step :step_two
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(**)
    ctx[:action_failed] = true
  end

  def step_two(**)
    ctx[:result] = 'Success'
  end
end

success_action = SomeActionOnSuccessFinishHim.call(param_for_step_one: true)
failure_action = SomeActionOnSuccessFinishHim.call(param_for_step_one: false)

success_action # =>
# Result: success

# RailwayFlow:
#   step_one

# Context:
#   :param_for_step_one => true

# Status: NONE

# Errors:
#   NONE

failure_action # =>
# Result: failure

# RailwayFlow:
#   step_one -> fail_one

# Context:
#   :param_for_step_one => false
#   :action_failed => true

# Status: NONE

# Errors:
#   NONE



# on_success: next success track step
class SomeActionOnSuccessToSuccessTrack < Decouplio::Action
  logic do
    step :step_one, on_success: :step_three
    fail :fail_one
    step :step_two
    step :step_three
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(**)
    ctx[:action_failed] = true
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def step_three(**)
    ctx[:result] = 'Result'
  end
end

success_action = SomeActionOnSuccessToSuccessTrack.call(param_for_step_one: true)
failure_action = SomeActionOnSuccessToSuccessTrack.call(param_for_step_one: false)
success_action # =>
# Result: success

# RailwayFlow:
#   step_one -> step_three

# Context:
#   :param_for_step_one => true
#   :result => "Result"

# Status: NONE

# Errors:
#   NONE


failure_action # =>
# Result: failure

# RailwayFlow:
#   step_one -> fail_one

# Context:
#   :param_for_step_one => false
#   :action_failed => true

# Status: NONE

# Errors:
#   NONE



# on_success: next failure track step
class SomeActionOnSuccessToFailureTrack < Decouplio::Action
  logic do
    step :step_one, on_success: :fail_two
    fail :fail_one
    step :step_two
    step :step_three
    fail :fail_two
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(**)
    ctx[:action_failed] = true
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def step_three(**)
    ctx[:result] = 'Result'
  end

  def fail_two(**)
    ctx[:fail_two] = 'Failure'
  end
end

success_action = SomeActionOnSuccessToFailureTrack.call(param_for_step_one: true)
failure_action = SomeActionOnSuccessToFailureTrack.call(param_for_step_one: false)
success_action # =>
# Result: failure

# RailwayFlow:
#   step_one -> fail_two

# Context:
#   :param_for_step_one => true
#   :fail_two => "Failure"

# Status: NONE

# Errors:
#   NONE


failure_action # =>
# Result: failure

# RailwayFlow:
#   step_one -> fail_one -> fail_two

# Context:
#   :param_for_step_one => false
#   :action_failed => true
#   :fail_two => "Failure"

# Status: NONE

# Errors:
#   NONE




# on_success: :FAIL

class SomeActionOnSuccessFail < Decouplio::Action
  logic do
    step :step_one
    step :step_two, on_success: :FAIL
  end

  def step_one(**)
    ctx[:step_one] = 'Success'
  end

  def step_two(step_two_param:, **)
    ctx[:step_two] = step_two_param
  end
end

success_action = SomeActionOnSuccessFail.call(step_two_param: true)
failure_action = SomeActionOnSuccessFail.call(step_two_param: false)

success_action # =>
# Result: failure

# RailwayFlow:
#   step_one -> step_two

# Context:
#   :step_two_param => true
#   :step_one => "Success"
#   :step_two => true

# Status: NONE

# Errors:
#   NONE


failure_action # =>
# Result: failure

# RailwayFlow:
#   step_one -> step_two

# Context:
#   :step_two_param => false
#   :step_one => "Success"
#   :step_two => false

# Status: NONE

# Errors:
#   NONE



# on_failure: :finish_him
class SomeActionOnFailureFinishHim < Decouplio::Action
  logic do
    step :step_one, on_failure: :finish_him
    fail :fail_one
    step :step_two
    fail :fail_two
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(**)
    ctx[:action_failed] = true
  end

  def step_two(**)
    ctx[:result] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'failure'
  end
end

success_action = SomeActionOnFailureFinishHim.call(param_for_step_one: true)
failure_action = SomeActionOnFailureFinishHim.call(param_for_step_one: false)
success_action # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two

# Context:
#   :param_for_step_one => true
#   :result => "Success"

# Status: NONE

# Errors:
#   NONE

failure_action # =>
# Result: failure

# RailwayFlow:
#   step_one

# Context:
#   :param_for_step_one => false

# Status: NONE

# Errors:
#   NONE



# on_failure: next success track step
class SomeActionOnFailureToSuccessTrack < Decouplio::Action
  logic do
    step :step_one, on_failure: :step_three
    fail :fail_one
    step :step_two
    fail :fail_two
    step :step_three
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(**)
    ctx[:action_failed] = true
  end

  def step_two(**)
    ctx[:result] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'failure'
  end

  def step_three(**)
    ctx[:step_three] = 'Success'
  end
end

success_action = SomeActionOnFailureToSuccessTrack.call(param_for_step_one: true)
failure_action = SomeActionOnFailureToSuccessTrack.call(param_for_step_one: false)
success_action # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two -> step_three

# Context:
#   :param_for_step_one => true
#   :result => "Success"
#   :step_three => "Success"

# Status: NONE

# Errors:
#   NONE


failure_action # =>
# Result: success

# RailwayFlow:
#   step_one -> step_three

# Context:
#   :param_for_step_one => false
#   :step_three => "Success"

# Status: NONE

# Errors:
#   NONE



# on_failure: next failure track step
class SomeActionOnFailureToFailureTrack < Decouplio::Action
  logic do
    step :step_one, on_failure: :fail_two
    fail :fail_one
    step :step_two
    fail :fail_two
    step :step_three
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(**)
    ctx[:action_failed] = true
  end

  def step_two(**)
    ctx[:result] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'failure'
  end

  def step_three(**)
    ctx[:step_three] = 'Success'
  end
end

success_action = SomeActionOnFailureToFailureTrack.call(param_for_step_one: true)
failure_action = SomeActionOnFailureToFailureTrack.call(param_for_step_one: false)
success_action # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two -> step_three

# Context:
#   :param_for_step_one => true
#   :result => "Success"
#   :step_three => "Success"

# Status: NONE

# Errors:
#   NONE


failure_action # =>
# Result: failure

# RailwayFlow:
#   step_one -> fail_two

# Context:
#   :param_for_step_one => false
#   :fail_two => "failure"

# Status: NONE

# Errors:
#   NONE



# on_failure: :PASS
class SomeActionOnFailurePass < Decouplio::Action
  logic do
    step :step_one
    step :step_two, on_failure: :PASS
  end

  def step_one(**)
    ctx[:step_one] = true
  end

  def step_two(step_two_param:, **)
    ctx[:step_two] = step_two_param
  end
end


success_action = SomeActionOnFailurePass.call(step_two_param: true)
failure_action = SomeActionOnFailurePass.call(step_two_param: false)

success_action # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two

# Context:
#   :step_two_param => true
#   :step_one => true
#   :step_two => true

# Status: NONE

# Errors:
#   NONE


failure_action # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two

# Context:
#   :step_two_param => false
#   :step_one => true
#   :step_two => false

# Status: NONE

# Errors:
#   NONE




# on_error: next success track step

class SomeActionOnErrorNextSuccessTrackStep < Decouplio::Action
  logic do
    step :step_one, on_error: :step_three
    resq handle_step_one: ArgumentError
    fail :fail_one
    step :step_two
    step :step_three
  end

  def step_one(step_one_lambda:, **)
    ctx[:step_one] = step_one_lambda.call
  end

  def fail_one(**)
    ctx[:fail_one] = 'Failure'
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def step_three(**)
    ctx[:step_three] = 'Success'
  end

  def handle_step_one(error, **)
    ctx[:handle_step_one] = error.message
  end
end

success_action = SomeActionOnErrorNextSuccessTrackStep.call(
  step_one_lambda: -> { true }
)
failed_action = SomeActionOnErrorNextSuccessTrackStep.call(
  step_one_lambda: -> { false }
)
erroneous_action = SomeActionOnErrorNextSuccessTrackStep.call(
  step_one_lambda: -> { raise ArgumentError, 'Some message' }
)

success_action # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two -> step_three

# Context:
#   :step_one_lambda => #<Proc:0x0000565032135d98 step.rb:742 (lambda)>
#   :step_one => true
#   :step_two => "Success"
#   :step_three => "Success"

# Status: NONE

# Errors:
#   NONE


failed_action # =>
# Result: failure

# RailwayFlow:
#   step_one -> fail_one

# Context:
#   :step_one_lambda => #<Proc:0x0000565032135938 step.rb:745 (lambda)>
#   :step_one => false
#   :fail_one => "Failure"

# Status: NONE

# Errors:
#   NONE


erroneous_action # =>
# Result: success

# RailwayFlow:
#   step_one -> handle_step_one -> step_three

# Context:
#   :step_one_lambda => #<Proc:0x0000565032135398 step.rb:748 (lambda)>
#   :handle_step_one => "Some message"
#   :step_three => "Success"

# Status: NONE

# Errors:
#   NONE




# if: condition method name
class SomeActionOnIfCondition < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one
    step :step_two
    fail :fail_two
    step :step_three, if: :step_condition?
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(**)
    ctx[:action_failed] = true
  end

  def step_two(**)
    ctx[:result] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'failure'
  end

  def step_three(**)
    ctx[:step_three] = 'Success'
  end

  def step_condition?(step_condition_param:, **)
    step_condition_param
  end
end

condition_positive = SomeActionOnIfCondition.call(
  param_for_step_one: true,
  step_condition_param: true
)
condition_negative = SomeActionOnIfCondition.call(
  param_for_step_one: true,
  step_condition_param: false
)
condition_positive # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two -> step_three

# Context:
#   :param_for_step_one => true
#   :step_condition_param => true
#   :result => "Success"
#   :step_three => "Success"

# Status: NONE

# Errors:
#   NONE


condition_negative # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two

# Context:
#   :param_for_step_one => true
#   :step_condition_param => false
#   :result => "Success"

# Status: NONE

# Errors:
#   NONE




# unless: condition method name
class SomeActionOnUnlessCondition < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one
    step :step_two
    fail :fail_two
    step :step_three, unless: :step_condition?
  end

  def step_one(param_for_step_one:, **)
    param_for_step_one
  end

  def fail_one(**)
    ctx[:action_failed] = true
  end

  def step_two(**)
    ctx[:result] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'failure'
  end

  def step_three(**)
    ctx[:step_three] = 'Success'
  end

  def step_condition?(step_condition_param:, **)
    step_condition_param
  end
end

condition_positive = SomeActionOnUnlessCondition.call(
  param_for_step_one: true,
  step_condition_param: true
)
condition_negative = SomeActionOnUnlessCondition.call(
  param_for_step_one: true,
  step_condition_param: false
)
condition_positive # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two

# Context:
#   :param_for_step_one => true
#   :step_condition_param => true
#   :result => "Success"

# Status: NONE

# Errors:
#   NONE


condition_negative # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two -> step_three

# Context:
#   :param_for_step_one => true
#   :step_condition_param => false
#   :result => "Success"
#   :step_three => "Success"

# Status: NONE

# Errors:
#   NONE
