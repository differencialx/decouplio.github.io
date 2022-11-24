require 'decouplio'

# Behavior
class SomeAction < Decouplio::Action
  logic do
    pass :pass_one
    step :step_two
    fail :fail_one
  end

  def pass_one
    ctx[:pass_one] = c.param_for_pass
  end

  def step_two
    ctx[:step_two] = 'Success'
  end

  def fail_one
    ctx[:fail_one] = 'Failure'
  end
end

pass_success = SomeAction.call(param_for_pass: true)
pass_failure = SomeAction.call(param_for_pass: false)

pass_success # =>
# Result: success

# RailwayFlow:
#   pass_one -> step_two

# Context:
#   :param_for_pass => true
#   :pass_one => true
#   :step_two => "Success"

# Status: NONE

# Errors:
#   NONE

pass_failure # =>
# Result: success

# RailwayFlow:
#   pass_one -> step_two

# Context:
#   :param_for_pass => false
#   :pass_one => false
#   :step_two => "Success"

# Status: NONE

# Errors:
#   NONE



# if: condition method name
class SomeActionIfCondition < Decouplio::Action
  logic do
    step :step_one
    pass :pass_one, if: :some_condition?
    step :step_two
  end

  def step_one
    ctx[:step_one] = 'Success'
  end

  def pass_one
    ctx[:pass_one] = 'Success'
  end

  def step_two
    ctx[:step_two] = 'Success'
  end

  def some_condition?
    c.condition_param
  end
end

condition_positive = SomeActionIfCondition.call(condition_param: true)
condition_negative = SomeActionIfCondition.call(condition_param: false)

condition_positive # =>
# Result: success

# RailwayFlow:
#   step_one -> pass_one -> step_two

# Context:
#   :condition_param => true
#   :step_one => "Success"
#   :pass_one => "Success"
#   :step_two => "Success"

# Status: NONE

# Errors:
#   NONE


condition_negative # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two

# Context:
#   :condition_param => false
#   :step_one => "Success"
#   :step_two => "Success"

# Status: NONE

# Errors:
#   NONE



# unless: condition method name
class SomeActionUnlessCondition < Decouplio::Action
  logic do
    step :step_one
    pass :pass_one, unless: :some_condition?
    step :step_two
  end

  def step_one
    ctx[:step_one] = 'Success'
  end

  def pass_one
    ctx[:pass_one] = 'Success'
  end

  def step_two
    ctx[:step_two] = 'Success'
  end

  def some_condition?
    c.condition_param
  end
end

condition_positive = SomeActionUnlessCondition.call(condition_param: false)
condition_negative = SomeActionUnlessCondition.call(condition_param: true)

condition_positive # =>
# Result: success

# RailwayFlow:
#   step_one -> pass_one -> step_two

# Context:
#   :condition_param => false
#   :step_one => "Success"
#   :pass_one => "Success"
#   :step_two => "Success"

# Status: NONE

# Errors:
#   NONE

condition_negative # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two

# Context:
#   :condition_param => true
#   :step_one => "Success"
#   :step_two => "Success"

# Status: NONE

# Errors:
#   NONE



# finish_him: true
class SomeActionFinishHim < Decouplio::Action
  logic do
    step :step_one, on_success: :step_two, on_failure: :pass_one
    pass :pass_one, finish_him: true
    step :step_two
    step :step_three
  end

  def step_one
    ctx[:step_one] = c.param_for_step
  end

  def pass_one
    ctx[:pass_one] = 'Success'
  end

  def step_two
    ctx[:step_two] = 'Success'
  end

  def step_three
    ctx[:step_three] = 'Success'
  end
end

success_track = SomeActionFinishHim.call(param_for_step: true)
failure_track = SomeActionFinishHim.call(param_for_step: false)

success_track # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two -> step_three

# Context:
#   :param_for_step => true
#   :step_one => true
#   :step_two => "Success"
#   :step_three => "Success"

# Status: NONE

# Errors:
#   NONE

failure_track # =>
# Result: success

# RailwayFlow:
#   step_one -> pass_one

# Context:
#   :param_for_step => false
#   :step_one => false
#   :pass_one => "Success"

# Status: NONE

# Errors:
#   NONE
