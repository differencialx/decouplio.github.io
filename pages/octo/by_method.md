---
layout: default
title: Using method
permalink: /octo_by_method/
parent: Octo
nav_order: 2
---

Octo key will be retrieved from method execution result.

```ruby
class OctoByMethod < Decouplio::Action
  logic do
    octo :octo_name, method: :retrieve_octo_key do
      on :octo_key1, :step_one
      on :octo_key2, :step_two
    end
  end

  def step_one
    ctx[:step_one] = 'step_one success'
  end

  def step_two
    ctx[:step_two] = 'step_two success'
  end

  def retrieve_octo_key
    c.octo_key
  end
end

OctoByMethod.call(octo_key: :octo_key1) # =>
# Result: success
# RailwayFlow:
#   octo_name -> octo_key1 -> step_one
# Context:
#   :octo_key => :octo_key1
#   :step_one => "step_one success"
# Status: NONE
# Errors:
#   NONE

OctoByMethod.call(octo_key: :octo_key2) # =>
# Result: success
# RailwayFlow:
#   octo_name -> octo_key2 -> step_two
# Context:
#   :octo_key => :octo_key2
#   :step_two => "step_two success"
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
      D(step_two)-->|success track|E(finish_success);
{% endmermaid %}
