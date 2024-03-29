require_relative '../../../decouplio/lib/decouplio'

class ResqAllAction < Decouplio::Action
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

success_action = ResqAllAction.call(lambda_for_step_one: -> { true })
failure_action = ResqAllAction.call(lambda_for_step_one: -> { false })
erroneous_action = ResqAllAction.call(
  lambda_for_step_one: -> { raise 'some error message' }
)

success_action # =>
# Result: success
# RailwayFlow:
#   step_one -> step_two
# Context:
#   :lambda_for_step_one => #<Proc:0x000055b2f3d57ea0 resq/resq_all.rb:28 (lambda)>
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
#   :lambda_for_step_one => #<Proc:0x000055b2f3d57c98 resq/resq_all.rb:29 (lambda)>
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
#   :lambda_for_step_one => #<Proc:0x000055b2f3d56d70 resq/resq_all.rb:31 (lambda)>
#   :error => "some error message"
#   :fail_one => "Failure"
# Status: NONE
# Errors:
#   NONE
