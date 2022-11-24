require_relative '../../../decouplio/lib/decouplio'

class OctoAsStep < Decouplio::Action
  logic do
    octo :octo_name, ctx_key: :octo_key do
      on :octo_key1, :step_one
      # Several steps could be also defined
      # such block will behave like simple 'warp' step
      on :octo_key2 do
        step :step_two
        step :step_one
      end
    end
  end

  def step_one
    ctx[:step_one] = 'step_one success'
  end

  def step_two
    ctx[:step_two] = 'step_two success'
  end
end

OctoAsStep.call(octo_key: :octo_key1) # =>
# Result: success
# RailwayFlow:
#   octo_name -> octo_key1 -> step_one
# Context:
#   :octo_key => :octo_key1
#   :step_one => "step_one success"
# Status: NONE
# Errors:
#   NONE


OctoAsStep.call(octo_key: :octo_key2) # =>
# Result: success
# RailwayFlow:
#   octo_name -> octo_key2 -> step_two -> step_one
# Context:
#   :octo_key => :octo_key2
#   :step_two => "step_two success"
#   :step_one => "step_one success"
# Status: NONE
# Errors:
#   NONE
