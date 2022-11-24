---
layout: default
title: Step as a service
permalink: /step_as_a_service/
has_children: true
nav_order: 8
---

# Step as a service

It's similar to [Inner action](/decouplio.github.io/inner_action), but instead of using `Decouplio::Action`, you can use PORO class.

## Signature

```ruby
(step|fail|pass)(service_class, **options)
```

## Behavior
- service class should implement `.call` class method
- service class can be used for `step` or `fail` or `pass`
- all options of `step|fail|pass` can be used, the same approach as for [Inner action](/decouplio.github.io/inner_action)
- depending on returning value of `.call` method(truthy ot falsy) the execution will be moved to `success or failure` track accordingly.
- All options passed after class constant will be passed as kwargs into `.call` method, except default step/fail/pass options like `on_success`, `on_failure`, `on_error`, `finish_him`, `if`, `unless`

## How to use?

Create a PORO class with `.call` class method.

```ruby
# ctx - required, it's a ctx from Decouplio::Action
# ms - required, it's an meta_store from Decouplio::Action
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

# OR

# ctx - required, it's a ctx from Decouplio::Action
# ms - required, it's an meta_store from Decouplio::Action
class Subtract
  def self.call(ctx, ms, **)
    ctx[:result] = ctx[:one] - ctx[:two]
  end
end

# OR

# :ctx - it's a ctx from Decouplio::Action
# :ms - it's an meta_store from Decouplio::Action
class MakeRequest
  def self.call(ctx, ms, **)
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
```
