require_relative '../../../decouplio/lib/decouplio'

class Semantic
  def self.call(ctx, ms, semantic:, error_message:)
    ms.status = semantic
    ms.add_error(semantic, error_message)
  end
end

class SomeActionSemantic < Decouplio::Action
  logic do
    step :step_one
    fail Semantic, semantic: :bad_request, error_message: 'Bad request'
    step :step_two
  end

  def step_one
    ctx[:step_one] = c.step_one_param
  end

  def step_two
    ctx[:step_two] = 'Success'
  end

  def fail_one
    ctx[:fail_one] = 'Failure'
  end
end

success_action = SomeActionSemantic.call(step_one_param: true)
failure_action = SomeActionSemantic.call(step_one_param: false)

success_action # =>
# Result: success
# RailwayFlow:
#   step_one -> step_two
# Context:
#   :step_one_param => true
#   :step_one => true
#   :step_two => "Success"
# Status: NONE
# Errors:
#   NONE

failure_action # =>
# Result: failure
# RailwayFlow:
#   step_one -> Semantic
# Context:
#   :step_one_param => false
#   :step_one => false
# Status: :bad_request
# Errors:
#   :bad_request => ["Bad request"]
