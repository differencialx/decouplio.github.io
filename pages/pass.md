---
layout: default
title: Pass
permalink: /pass/
nav_order: 3
---

# Pass

`pass` is the step type that always moves to success track `logic` steps

## Signature

```ruby
pass(step_name, **options)
```

## Behavior

 - when step method(`#pass_one`) returns truthy or falsy value then it goes to success track(`step_two` step)

```ruby
require 'decouplio'

class SomeAction < Decouplio::Action
  logic do
    pass :pass_one
    step :step_two
    fail :fail_one
  end

  def pass_one
    ctx[:pass_one] = c.param_for_pass
  end

  def step_two
    ctx[:step_two] = 'Success'
  end

  def fail_one
    ctx[:fail_one] = 'Failure'
  end
end

pass_success = SomeAction.call(param_for_pass: true)
pass_failure = SomeAction.call(param_for_pass: false)

pass_success # =>
# Result: success

# RailwayFlow:
#   pass_one -> step_two

# Context:
#   :param_for_pass => true
#   :pass_one => true
#   :step_two => "Success"

# Status: NONE

# Errors:
#   NONE

pass_failure # =>
# Result: success

# RailwayFlow:
#   pass_one -> step_two

# Context:
#   :param_for_pass => false
#   :pass_one => false
#   :step_two => "Success"

# Status: NONE

# Errors:
#   NONE
```

{% mermaid %}
    flowchart LR;
        1(start)-->2(pass_one success);
        1(start)-->3(pass_one failure);
        2(pass_one success)-->|success track|4(step_two);
        3(pass_one failure)-->|success track|4(step_two);
        4(step_two)-->|success track|5(finish_success)
{% endmermaid %}
***
