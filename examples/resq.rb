require_relative '../../decouplio/lib/decouplio'


## When without specified error class
class ResqWithoutErrorClassAction < Decouplio::Action
  logic do
    step :step_one
    resq :handler_method
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

success_action = ResqWithoutErrorClassAction.call(lambda_for_step_one: -> { true })
failure_action = ResqWithoutErrorClassAction.call(lambda_for_step_one: -> { false })
erroneous_action = ResqWithoutErrorClassAction.call(
  lambda_for_step_one: -> { raise 'some error message' }
)

success_action # =>
# Result: success
# RailwayFlow:
#   step_one -> step_two
# Context:
#   :lambda_for_step_one => #<Proc:0x000055bdf9e22018 resq.rb:30 (lambda)>
#   :step_one => true
#   :step_two => "Success"
# Status: nil
# Errors:
#   NONE

failure_action # =>
# Result: failure
# RailwayFlow:
#   step_one -> fail_one
# Context:
#   :lambda_for_step_one => #<Proc:0x000055bdf9e21eb0 resq.rb:31 (lambda)>
#   :step_one => false
#   :fail_one => "Failure"
# Status: nil
# Errors:
#   NONE


erroneous_action # =>
# Result: failure
# RailwayFlow:
#   step_one -> handler_method -> fail_one
# Context:
#   :lambda_for_step_one => #<Proc:0x000055bff7675e28 resq.rb:33 (lambda)>
#   :error => "some error message"
#   :fail_one => "Failure"
# Status: NONE
# Errors:
#   NONE


## When error class is specified
class ResqWithClassAction < Decouplio::Action
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

success_action = ResqWithClassAction.call(lambda_for_step_one: -> { true })
failure_action = ResqWithClassAction.call(lambda_for_step_one: -> { false })
erroneous_action = ResqWithClassAction.call(
  lambda_for_step_one: -> { raise ArgumentError, 'some error message' }
)

success_action # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two

# Context:
#   :lambda_for_step_one => #<Proc:0x000055cd61ed4318 resq.rb:32 (lambda)>
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
#   :lambda_for_step_one => #<Proc:0x000055cd61eccac8 resq.rb:33 (lambda)>
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
#   :lambda_for_step_one => #<Proc:0x000055cd61ebf5d0 resq.rb:35 (lambda)>
#   :error => "some error message"
#   :fail_one => "Failure"

# Status: NONE

# Errors:
#   NONE



# When several error handlers and error classes
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
#   :lambda_for_step_one => #<Proc:0x000055cac05811d8 resq.rb:119 (lambda)>
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
#   :lambda_for_step_one => #<Proc:0x000055cac0580eb8 resq.rb:122 (lambda)>
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
#   :lambda_for_step_one => #<Proc:0x000055cac0580bc0 resq.rb:125 (lambda)>
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
#   :lambda_for_step_one => #<Proc:0x000055cac05807d8 resq.rb:128 (lambda)>
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
#   :lambda_for_step_one => #<Proc:0x000055cac0573ec0 resq.rb:131 (lambda)>
#   :error => "NotImplementedError error message"
#   :fail_one => "Failure"

# Status: NONE

# Errors:
#   NONE
