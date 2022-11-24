require_relative '../../../decouplio/lib/decouplio'

class WrapperClass
  def self.call(&block)
    if block_given?
      puts 'Before wrapper action execution'
      block.call
      puts 'After wrapper action execution'
    end
  end
end

class SomeActionWrapKlassMethod < Decouplio::Action
  logic do
    wrap :wrap_one, klass: WrapperClass do
      step :step_one
      step :step_two
    end
  end

  def step_one
    puts 'Step one'
    ctx[:step_one] = 'Success'
  end

  def step_two
    puts 'Step two'
    ctx[:step_two] = 'Success'
  end
end

action = SomeActionWrapKlassMethod.call # =>
# Before wrapper action execution
# Step one
# Step two
# After wrapper action execution

action # =>
# Result: success
# RailwayFlow:
#   wrap_one -> step_one -> step_two
# Context:
#   :step_one => "Success"
#   :step_two => "Success"
# Status: NONE
# Errors:
#   NONE
