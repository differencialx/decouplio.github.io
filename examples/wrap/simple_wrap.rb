require_relative '../../../decouplio/lib/decouplio'

class SomeAction < Decouplio::Action
  logic do
    step :step_one

    wrap :wrap_one do
      step :step_two
      fail :fail_one
    end

    step :step_three
    fail :fail_two
  end

  def step_one
    ctx[:step_one] = c.param_for_step_one
  end

  def step_two
    ctx[:step_two]= c.param_for_step_two
  end

  def fail_one
    ctx[:fail_one] = 'Fail one failure'
  end

  def step_three
    ctx[:step_three] = 'Success'
  end

  def fail_two
    ctx[:fail_two] = 'Fail two failure'
  end
end

success_wrap_success = SomeAction.call(
  param_for_step_one: true,
  param_for_step_two: true
)
success_wrap_failure = SomeAction.call(
  param_for_step_one: true,
  param_for_step_two: false
)
failure = SomeAction.call(
  param_for_step_one: false
)

success_wrap_success # =>
# Result: success
# RailwayFlow:
#   step_one -> wrap_one -> step_two -> step_three
# Context:
#   :param_for_step_one => true
#   :param_for_step_two => true
#   :step_one => true
#   :step_two => true
#   :step_three => "Success"
# Status: NONE
# Errors:
#   NONE

success_wrap_failure # =>
# Result: failure
# RailwayFlow:
#   step_one -> wrap_one -> step_two -> fail_one -> fail_two
# Context:
#   :param_for_step_one => true
#   :param_for_step_two => false
#   :step_one => true
#   :step_two => false
#   :fail_one => "Fail one failure"
#   :fail_two => "Fail two failure"
# Status: NONE
# Errors:
#   NONE


failure # =>
# Result: failure
# RailwayFlow:
#   step_one -> fail_two
# Context:
#   :param_for_step_one => false
#   :step_one => false
#   :fail_two => "Fail two failure"
# Status: NONE
# Errors:
#   NONE
