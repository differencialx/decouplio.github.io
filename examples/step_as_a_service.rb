require 'decouplio'

class Concat
  def self.call(ctx:, **)
    new(ctx: ctx).call
  end

  def initialize(ctx:)
    @ctx = ctx
  end

  def call
    @ctx[:result] = @ctx[:one] + @ctx[:two]
  end
end

class Subtract
  def self.call(ctx:, **)
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

  def init_one(param_one:, **)
    ctx[:one] = param_one
  end

  def init_two(param_two:, **)
    ctx[:two] = param_two
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



# Example With additional options

class Semantic
  def self.call(ctx:, ms:, semantic:, error_message:)
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

  def step_one(step_one_param:, **)
    ctx[:step_one] = step_one_param
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def fail_one(**)
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

# Status: bad_request

# Errors:
#   :bad_request => ["Bad request"]
