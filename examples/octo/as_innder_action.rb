require_relative '../../../decouplio/lib/decouplio'


class InnerActionOne < Decouplio::Action
  logic do
    step :inner_step_one
  end

  def inner_step_one
    ctx[:inner_step_one] = 'Inner step one'
  end
end

class InnerActionTwo < Decouplio::Action
  logic do
    step :inner_step_two
  end

  def inner_step_two
    ctx[:inner_step_two] = 'Inner step two'
  end
end

class OctoInnerAction < Decouplio::Action
  logic do
    octo :octo_name, ctx_key: :octo_key do
      on :octo_key1, InnerActionOne
      on :octo_key2, InnerActionTwo
    end
  end
end

puts OctoInnerAction.call(octo_key: :octo_key1) # =>
# Result: success
# RailwayFlow:
#   octo_name -> octo_key1 -> InnerActionOne -> inner_step_one
# Context:
#   :octo_key => :octo_key1
#   :inner_step_one => "Inner step one"
# Status: NONE
# Errors:
  # NONE

puts OctoInnerAction.call(octo_key: :octo_key2) # =>
# Result: success
# RailwayFlow:
#   octo_name -> octo_key2 -> InnerActionTwo -> inner_step_two
# Context:
#   :octo_key => :octo_key2
#   :inner_step_two => "Inner step two"
# Status: NONE
# Errors:
#   NONE
