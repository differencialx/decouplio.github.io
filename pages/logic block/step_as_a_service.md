---
layout: default
title: Step as a service
permalink: /step_as_a_service/
parent: Logic block
nav_order: 9
---

# Step as a service

It's similar to [Inner action](/decouplio.github.io/inner_action), but instead of using `Decouplio::Action`, you can use PORO class.

## Signature

```ruby
(step|fail|pass)(service_class, **options)
```

## Behavior

- service class should implement `.call` class method
- service class can be used as `step` or `fail` or `pass`
- all options of `step|fail|pass` can be used as for [Inner action](/decouplio.github.io/inner_action)
- depending on returning value of `.call` method(truthy ot falsy) the execution will be moved to `success or failure` track accordingly.
- All options passed after class constant will be passed as kwargs into `.call` method, except default step/fail/pass options like `on_success`, `on_failure`, `on_error`, `finish_him`, `if`, `unless`

## How to use?

Create a PORO class with `.call` class method.

```ruby
# :ctx - it's a ctx from Decouplio::Action
# :ms - it's an meta_store from Decouplio::Action
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

# OR

# :ctx - it's a ctx from Decouplio::Action
# :ms - it's an meta_store from Decouplio::Action
class Subtract
  def self.call(ctx:, **)
    ctx[:result] = ctx[:one] - ctx[:two]
  end
end

# OR

# :ctx - it's a ctx from Decouplio::Action
# :ms - it's an meta_store from Decouplio::Action
class MakeRequest
  def self.call(ctx:, ms:)
    ctx[:client].get(ctx[:url])
  rescue Net::OpenTimeout => error
    ms.status = :timeout_error
    ms.add_error(:connection_error, error.message)
  end
end
```

Now you can use these classes as a `step|fail|pass` step

```ruby
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
```

OR

```ruby
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

```

### Example With additional options

```ruby
require 'decouplio'

class Semantic
  def self.call(ctx:, ms:, semantic:, error_message:)
    ms.status = semantic
    ms.add_error(semantic, error_message)
  end
end

class SomeAction < Decouplio::Action
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

success_action = SomeAction.call(step_one_param: true)
failure_action = SomeAction.call(step_one_param: false)

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
```
