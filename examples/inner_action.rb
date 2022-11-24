require_relative '../../decouplio/lib/decouplio'

class InnerAction < Decouplio::Action
  logic do
    step :step_one
    step :step_two
  end

  def step_one
    ctx # => ctx from parent action(SomeAction)
    ctx[:step_one] = 'Success'
  end

  def step_two
    ctx # => ctx from parent action(SomeAction)
    ctx[:step_two] = 'Success'
  end
end


class SomeAction < Decouplio::Action
  logic do
    step InnerAction
    # OR
    # fail InnerAction
    # OR
    # pass InnerAction
  end
end

action = SomeAction.call

action # =>
# Result: success
# RailwayFlow:
#   InnerAction -> step_one -> step_two
# Context:
#   :step_one => "Success"
#   :step_two => "Success"
# Status: NONE
# Errors:
#   NONE
