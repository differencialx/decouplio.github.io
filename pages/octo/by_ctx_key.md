---
layout: default
title: Using context key
permalink: /octo_by_ctx_key/
parent: Octo
nav_order: 1
---

# Octo by ctx_key

`ctx_key` option will use value from action context placed under specified key.

```ruby
class OctoByKey < Decouplio::Action
  logic do
    octo :octo_name, ctx_key: :octo_key do
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
end

OctoByKey.call(octo_key: :octo_key1) # =>
# Result: success
# RailwayFlow:
#   octo_name -> octo_key1 -> step_one
# Context:
#   :octo_key => :octo_key1
#   :step_one => "step_one success"
# Status: NONE
# Errors:
#   NONE

OctoByKey.call(octo_key: :octo_key2) # =>
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
