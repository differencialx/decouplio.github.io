---
layout: default
title: Simple wrap
permalink: /simple_wrap/
parent: Wrap
nav_order: 1
---

# Simple wrap


```ruby
class SomeAction < Decouplio::Action
  logic do
    step :step_one

    wrap :wrap_one do
      step :step_two
      fail :fail_one
    end

    step :step_three
    fail :fail_two
  end

  def step_one(param_for_step_one:, **)
    ctx[:step_one] = param_for_step_one
  end

  def step_two(param_for_step_two:, **)
    ctx[:step_two]= param_for_step_two
  end

  def fail_one(**)
    ctx[:fail_one] = 'Fail one failure'
  end

  def step_three(**)
    ctx[:step_three] = 'Success'
  end

  def fail_two(**)
    ctx[:fail_two] = 'Fail two failure'
  end
end

success_wrap_success = SomeAction.call(
  param_for_step_one: true,
  param_for_step_two: true
)
success_wrap_failure = SomeAction.call(
  param_for_step_one: true,
  param_for_step_two: false
)
failure = SomeAction.call(
  param_for_step_one: false
)

success_wrap_success # =>
# Result: success

# RailwayFlow:
#   step_one -> wrap_one -> step_two -> step_three

# Context:
#   :param_for_step_one => true
#   :param_for_step_two => true
#   :step_one => true
#   :step_two => true
#   :step_three => "Success"

# Status: NONE

# Errors:
#   NONE


success_wrap_failure # =>
# Result: failure

# RailwayFlow:
#   step_one -> wrap_one -> step_two -> fail_one -> fail_two

# Context:
#   :param_for_step_one => true
#   :param_for_step_two => false
#   :step_one => true
#   :step_two => false
#   :fail_one => "Fail one failure"
#   :fail_two => "Fail two failure"

# Status: NONE

# Errors:
#   NONE

failure # =>
# Result: failure

# RailwayFlow:
#   step_one -> fail_two

# Context:
#   :param_for_step_one => false
#   :step_one => false
#   :fail_two => "Fail two failure"

# Status: NONE

# Errors:
#   NONE
```

{% mermaid %}
  flowchart TD;
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(wrap_one);
      subgraph wrap action;
      3(wrap_one)-->|success track|4(start);
      4(start)-->5(step_two);
      5(step_two)-->|success track|6(finish success);
      5(step_two)-->|failure track|9(fail_one);
      9(fail_one)-->|failure track|10(finish failure);
      end;
      6(finish success)-->|success track|7(step_three);
      7(step_three)-->|success track|8(finish success);
      10(finish failure)-->|failure track|11(fail_two);
      11(fail_two)-->|failure track|12(finish failure);
      2(step_one)-->|failure track|11(fail_two)
{% endmermaid %}
