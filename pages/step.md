---
layout: default
title: Step
permalink: /step/
nav_order: 1
---

# Step

`step` is the basic type of `logic` steps

## Signature

```ruby
step(step_name, **options)
```

## Behavior

 - when step method(`#step_one`) returns truthy value then it goes to success track(`step_two` step)
 - when step method(`#step_one`) returns falsy value then it goes to failure track(`fail_one` step)

```ruby
require 'decouplio'

class SomeAction < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one
    step :step_two
  end

  def step_one
    c.param_for_step_one
  end

  def fail_one
    ctx[:action_failed] = true
  end

  def step_two
    ctx[:result] = 'Success'
  end
end

success_action = SomeAction.call(param_for_step_one: true)
failure_action = SomeAction.call(param_for_step_one: false)

success_action # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two

# Context:
#   :param_for_step_one => true
#   :result => "Success"

# Status: NONE

# Errors:
#   NONE

failure_action # =>
# Result: failure

# RailwayFlow:
#   step_one -> fail_one

# Context:
#   :param_for_step_one => false
#   :action_failed => true

# Status: NONE

# Errors:
#   NONE
```

{% mermaid %}
  flowchart LR;
      A(start)-->B(step_one);
      B(step_one)-->|success track|C(step_two);
      B(step_one)-->|failure track|D(fail_one);
      C(step_two)-->|success track|E(finish_success);
      D(fail_one)-->|failure track|F(finish_failure);
{% endmermaid %}

***
