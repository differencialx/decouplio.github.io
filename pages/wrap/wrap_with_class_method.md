---
layout: default
title: With class and method
permalink: /with_class_method/
parent: Wrap
nav_order: 2
---

# Wrap with class and method

```ruby
require 'decouplio'

class WrapperClass
  def self.some_wrapper_method(&block)
    if block_given?
      puts 'Before wrapper action execution'
      block.call
      puts 'After wrapper action execution'
    end
  end
end

class SomeActionWrapKlassMethod < Decouplio::Action
  logic do
    wrap :wrap_one, klass: WrapperClass, method: :some_wrapper_method do
      step :step_one
      step :step_two
    end
  end

  def step_one(**)
    puts 'Step one'
    ctx[:step_one] = 'Success'
  end

  def step_two(**)
    puts 'Step two'
    ctx[:step_two] = 'Success'
  end
end

action = SomeActionWrapKlassMethod.call # =>
# Before wrapper action execution
# Step one
# Step two
# After wrapper action execution

action # =>
# Result: success

# RailwayFlow:
#   wrap_one -> step_one -> step_two

# Context:
#   :step_one => "Success"
#   :step_two => "Success"

# Status: NONE

# Errors:
#   NONE
  ```

{% mermaid %}
  flowchart LR;
      1(start)-->2(wrap_one);
      subgraph wrap action;
      2(wrap_one)-->|success track|3(step_one);
      3(step_one)-->|success track|4(step_two);
      4(step_two)-->|success track|5(finish success);
      end;
      5(finish success)-->|success track|6(finish success)
{% endmermaid %}
