---
layout: default
title: With inner action
permalink: /octo_as_inner_action/
parent: Octo
nav_order: 4
---

Octo with inner action

```ruby
class InnerActionOne < Decouplio::Action
  logic do
    step :inner_step_one
  end

  def inner_step_one
    ctx[:inner_step_one] = 'Inner step one'
  end
end

class InnerActionTwo < Decouplio::Action
  logic do
    step :inner_step_two
  end

  def inner_step_two
    ctx[:inner_step_two] = 'Inner step two'
  end
end

class OctoAsInnerAction < Decouplio::Action
  logic do
    octo :octo_name, ctx_key: :octo_key do
      on :octo_key1, InnerActionOne
      on :octo_key2, InnerActionTwo
    end
  end
end

OctoAsInnerAction.call(octo_key: :octo_key1) # =>
# Result: success
# RailwayFlow:
#   octo_name -> octo_key1 -> InnerActionOne -> inner_step_one
# Context:
#   :octo_key => :octo_key1
#   :inner_step_one => "Inner step one"
# Status: NONE
# Errors:
  # NONE

OctoAsInnerAction.call(octo_key: :octo_key2) # =>
# Result: success
# RailwayFlow:
#   octo_name -> octo_key2 -> InnerActionTwo -> inner_step_two
# Context:
#   :octo_key => :octo_key2
#   :inner_step_two => "Inner step two"
# Status: NONE
# Errors:
#   NONE
```

{% mermaid %}
  flowchart LR;
      1(start)-->2(octo_name);
      2(octo_name)-->|when :octo_key1|4(inner_step_one);
      2(octo_name)-->|when :octo_key2|6(inner_step_two);
      subgraph InnerActionOne;
      4(inner_step_one)-->7(finish_success);
      end;
      subgraph InnerActionTwo;
      6(inner_step_two)-->8(finish_success);
      end;
      7(finish_success)-->9(finish_success);
      8(finish_success)-->9(finish_success);
{% endmermaid %}
