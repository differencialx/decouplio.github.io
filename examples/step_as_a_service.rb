require_relative '../../decouplio/lib/decouplio'

class Concat
  def self.call(ctx, ms, **)
    new(ctx).call
  end

  def initialize(ctx)
    @ctx = ctx
  end

  def call
    @ctx[:result] = @ctx[:one] + @ctx[:two]
  end
end

class Subtract
  def self.call(ctx, ms, **)
    ctx[:result] = ctx[:one] - ctx[:two]
  end
end

class SomeActionConcat < Decouplio::Action
  logic do
    step Concat
  end
end

action = SomeActionConcat.call(one: 1, two: 2)

action[:result] # => 3

action # =>
# Result: success
# RailwayFlow:
#   Concat
# Context:
#   :one => 1
#   :two => 2
#   :result => 3
# Status: NONE
# Errors:
#   NONE



class SomeActionSubtract < Decouplio::Action
  logic do
    step :init_one
    step :init_two
    step Subtract
  end

  def init_one
    ctx[:one] = c.param_one
  end

  def init_two
    ctx[:two] = c.param_two
  end
end

action = SomeActionSubtract.call(param_one: 5, param_two: 2)

action[:result] # => 3

action # =>
# Result: success
# RailwayFlow:
#   init_one -> init_two -> Subtract
# Context:
#   :param_one => 5
#   :param_two => 2
#   :one => 5
#   :two => 2
#   :result => 3
# Status: NONE
# Errors:
#   NONE
