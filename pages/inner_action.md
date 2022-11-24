---
layout: default
title: Inner action
permalink: /inner_action/
nav_order: 7
---

# Inner Action

`step/fail/pass` steps can perform another action instead of method.

Context from parent action will be passed to inner action.

Depending on inner action result(`success|failure`) next success or failure track step will be executed.

**NOTE:** Be careful, as inner actions can override parent context.

```ruby
require 'decouplio'

class InnerAction < Decouplio::Action
  logic do
    step :step_one
    step :step_two
  end

  def step_one
    ctx # => ctx from parent action(SomeAction)
    ctx[:step_one] = 'Success'
  end

  def step_two
    ctx # => ctx from parent action(SomeAction)
    ctx[:step_two] = 'Success'
  end
end


class SomeAction < Decouplio::Action
  logic do
    step InnerAction
    # OR
    # fail InnerAction
    # OR
    # pass InnerAction
  end
end

action = SomeAction.call

action # =>
# Result: success
# RailwayFlow:
#   InnerAction -> step_one -> step_two
# Context:
#   :step_one => "Success"
#   :step_two => "Success"
# Status: NONE
# Errors:
#   NONE

```

{% mermaid %}
  flowchart LR;
      1(start)-->2(any_name);
      subgraph inner action;
      2(step_one)-->|success track|3(step_two);
      end;
      3(step_two)-->|success track|4(finish success);
{% endmermaid %}

The parent action context will be passed into inner action

## Options
All options for `step/fail/pass` can be applied for inner action step.
