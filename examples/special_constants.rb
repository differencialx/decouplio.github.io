require_relative '../../decouplio/lib/decouplio'

class SomeAction < Decouplio::Action
  logic do
    step :step_one
  end

  def step_one
    FAIL
  end
end

SomeAction.call #=>
# Result: failure
# RailwayFlow:
#   step_one
# Context:
#   Empty
# Status: NONE
# Errors:
#   NONE
