---
layout: default
title: With steps
permalink: /octo_as_steps/
parent: Octo
nav_order: 3
---

You can specify a single step or several steps for octo case

```ruby
  logic do
    octo :octo_name, ctx_key: :octo_key do
      on :octo_key1, :step_one
      # Several steps could be also defined
      # such block will behave like simple 'warp' step
      on :octo_key2 do
        step :step_two
        step :step_one
      end
    end
  end

  def step_one
    ctx[:step_one] = 'step_one success'
  end

  def step_two
    ctx[:step_two] = 'step_two success'
  end
end

OctoAsStep.call(octo_key: :octo_key1) # =>
# Result: success
# RailwayFlow:
#   octo_name -> octo_key1 -> step_one
# Context:
#   :octo_key => :octo_key1
#   :step_one => "step_one success"
# Status: NONE
# Errors:
#   NONE


OctoAsStep.call(octo_key: :octo_key2) # =>
# Result: success
# RailwayFlow:
#   octo_name -> octo_key2 -> step_two -> step_one
# Context:
#   :octo_key => :octo_key2
#   :step_two => "step_two success"
#   :step_one => "step_one success"
# Status: NONE
# Errors:
#   NONE
```

{% mermaid %}
  flowchart LR;
      A(start)-->B(octo_name);
      B(octo_name)-->|when :octo_key1|C(step_one);
      B(octo_name)-->|when :octo_key2|D(step_two);
      C(step_one)-->|success track|E(finish_success);
      D(step_two)-->|success track|F(step_one);
      F(step_one)-->|success track|E(finish_success);
{% endmermaid %}
