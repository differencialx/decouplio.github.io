---
layout: default
title: Fail
permalink: /fail/
nav_order: 2
---

# Fail

`fail` is the special type of step to mark failure track

## Signature

```ruby
fail(step_name, **options)
```

## Behavior

 - when step method(`#fail_one`) returns truthy or falsy value then it goes to failure track(`fail_two` step) unless `on_success:` or `on_failure:` option were specified(see `on_success, on_failure` docs)

```ruby
require 'decouplio'

class SomeAction < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one
    fail :fail_two
  end

  def step_one
    c.param_for_step_one
  end

  def fail_one
    ctx[:action_failed] = true
  end

  def fail_two
    ctx[:fail_two] = 'Failure'
  end
end

success_action = SomeAction.call(param_for_step_one: true)
failure_action = SomeAction.call(param_for_step_one: false)

success_action # =>
# Result: success

# RailwayFlow:
#   step_one

# Context:
#   :param_for_step_one => true

# Status: NONE

# Errors:
#   NONE


failure_action # =>
# Result: failure

# RailwayFlow:
#   step_one -> fail_one -> fail_two

# Context:
#   :param_for_step_one => false
#   :action_failed => true
#   :fail_two => "Failure"

# Status: NONE

# Errors:
#   NONE
```

{% mermaid %}
flowchart LR;
    1(start)-->2(step_one);
    2(step_one)-->|success track|3(finish_success);
    2(step_one)-->|failure track|4(fail_one);
    4(fail_one)-->|failure track|5(fail_two);
    5(fail_two)-->|failure track|F(finish_failure);
{% endmermaid %}
