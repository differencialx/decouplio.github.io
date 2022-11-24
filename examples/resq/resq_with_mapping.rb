require_relative '../../../decouplio/lib/decouplio'

class SomeAction < Decouplio::Action
  logic do
    step :step_one
    resq handler_method: ArgumentError
    step :step_two
    fail :fail_one
  end

  def step_one
    ctx[:step_one] = c.lambda_for_step_one.call
  end

  def step_two
    ctx[:step_two] = 'Success'
  end

  def fail_one
    ctx[:fail_one] = 'Failure'
  end

  def handler_method(error)
    ctx[:error] = error.message
  end
end

success_action = SomeAction.call(lambda_for_step_one: -> { true })
failure_action = SomeAction.call(lambda_for_step_one: -> { false })
erroneous_action = SomeAction.call(
  lambda_for_step_one: -> { raise ArgumentError, 'some error message' }
)

success_action # =>
# Result: success
# RailwayFlow:
#   step_one -> step_two
# Context:
#   :lambda_for_step_one => #<Proc:0x000055c8274f40f8 resq/resq_with_mapping.rb:28 (lambda)>
#   :step_one => true
#   :step_two => "Success"
# Status: NONE
# Errors:
#   NONE

failure_action # =>
# Result: failure
# RailwayFlow:
#   step_one -> fail_one
# Context:
#   :lambda_for_step_one => #<Proc:0x000055c8273d7e68 resq/resq_with_mapping.rb:29 (lambda)>
#   :step_one => false
#   :fail_one => "Failure"
# Status: NONE
# Errors:
#   NONE

erroneous_action # =>
# Result: failure
# RailwayFlow:
#   step_one -> handler_method -> fail_one
# Context:
#   :lambda_for_step_one => #<Proc:0x000055c8273d7508 resq/resq_with_mapping.rb:31 (lambda)>
#   :error => "some error message"
#   :fail_one => "Failure"
# Status: NONE
# Errors:
#   NONE


class SomeActionSeveralHandlersErrorClasses < Decouplio::Action
  logic do
    step :step_one
    resq handler_method_one: [ArgumentError, NoMethodError],
         handler_method_two: NotImplementedError
    step :step_two
    fail :fail_one
  end

  def step_one
    ctx[:step_one] = c.lambda_for_step_one.call
  end

  def step_two
    ctx[:step_two] = 'Success'
  end

  def fail_one
    ctx[:fail_one] = 'Failure'
  end

  def handler_method_one(error)
    ctx[:error] = error.message
  end

  def handler_method_two(error)
    ctx[:error] = error.message
  end
end

success_action = SomeActionSeveralHandlersErrorClasses.call(
  lambda_for_step_one: -> { true }
)
failure_action = SomeActionSeveralHandlersErrorClasses.call(
  lambda_for_step_one: -> { false }
)
argument_error_action = SomeActionSeveralHandlersErrorClasses.call(
  lambda_for_step_one: -> { raise ArgumentError, 'Argument error message' }
)
no_method_error_action = SomeActionSeveralHandlersErrorClasses.call(
  lambda_for_step_one: -> { raise NoMethodError, 'NoMethodError error message' }
)
no_implemented_error_action = SomeActionSeveralHandlersErrorClasses.call(
  lambda_for_step_one: -> { raise NotImplementedError, 'NotImplementedError error message' }
)

success_action # =>
# Result: success
# RailwayFlow:
#   step_one -> step_two
# Context:
#   :lambda_for_step_one => #<Proc:0x000055e5d6d61d68 resq/resq_with_mapping.rb:102 (lambda)>
#   :step_one => true
#   :step_two => "Success"
# Status: NONE
# Errors:
#   NONE

failure_action # =>
# Result: failure
# RailwayFlow:
#   step_one -> fail_one
# Context:
#   :lambda_for_step_one => #<Proc:0x000055e5d6d61c00 resq/resq_with_mapping.rb:105 (lambda)>
#   :step_one => false
#   :fail_one => "Failure"
# Status: NONE
# Errors:
#   NONE

argument_error_action # =>
# Result: failure
# RailwayFlow:
#   step_one -> handler_method_one -> fail_one
# Context:
#   :lambda_for_step_one => #<Proc:0x000055e5d6d61a98 resq/resq_with_mapping.rb:108 (lambda)>
#   :error => "Argument error message"
#   :fail_one => "Failure"
# Status: NONE
# Errors:
#   NONE

no_method_error_action # =>
# Result: failure
# RailwayFlow:
#   step_one -> handler_method_one -> fail_one
# Context:
#   :lambda_for_step_one => #<Proc:0x000055e5d6d61868 resq/resq_with_mapping.rb:111 (lambda)>
#   :error => "NoMethodError error message"
#   :fail_one => "Failure"
# Status: NONE
# Errors:
#   NONE

no_implemented_error_action # =>
# Result: failure
# RailwayFlow:
#   step_one -> handler_method_two -> fail_one
# Context:
#   :lambda_for_step_one => #<Proc:0x000055e5d6d614a8 resq/resq_with_mapping.rb:114 (lambda)>
#   :error => "NotImplementedError error message"
#   :fail_one => "Failure"
# Status: NONE
# Errors:
#   NONE
