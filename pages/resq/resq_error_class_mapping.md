---
layout: default
title: Resq with mapping
permalink: /rescue_with_mapping/
parent: Resq
nav_order: 2
---

# Resq with error class mapping

## With one handler method and class

```ruby
require 'decouplio'

class SomeAction < Decouplio::Action
  logic do
    step :step_one
    resq handler_method: ArgumentError
    step :step_two
    fail :fail_one
  end

  def step_one(lambda_for_step_one:, **)
    ctx[:step_one] = lambda_for_step_one.call
  end

  def step_two(**)
    ctx[:step_two] = 'Success'
  end

  def fail_one(**)
    ctx[:fail_one] = 'Failure'
  end

  def handler_method(error, **this_is_ctx)
    ctx[:error] = error.message
  end
end

success_action = SomeAction.call(lambda_for_step_one: -> { true })
failure_action = SomeAction.call(lambda_for_step_one: -> { false })
erroneous_action = SomeAction.call(
  lambda_for_step_one: -> { raise ArgumentError, 'some error message' }
)

success_action # =>
# Result: success

# RailwayFlow:
#   step_one -> step_two

# Context:
#   :lambda_for_step_one => #<Proc:0x000055cd61ed4318 resq.rb:32 (lambda)>
#   :step_one => true
#   :step_two => "Success"

# Status: NONE

# Errors:
#   NONE
failure_action # =>
# Result: failure

# RailwayFlow:
#   step_one -> fail_one

# Context:
#   :lambda_for_step_one => #<Proc:0x000055cd61eccac8 resq.rb:33 (lambda)>
#   :step_one => false
#   :fail_one => "Failure"

# Status: NONE

# Errors:
#   NONE

erroneous_action # =>
# Result: failure

# RailwayFlow:
#   step_one -> handler_method -> fail_one

# Context:
#   :lambda_for_step_one => #<Proc:0x000055cd61ebf5d0 resq.rb:35 (lambda)>
#   :error => "some error message"
#   :fail_one => "Failure"

# Status: NONE

# Errors:
#   NONE
```

{% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|4(finish success);
      2(step_one)-->|failure track|5(fail_one);
      5(fail_one)-->|failure track|6(finish failure);
      2(step_one)-->|error track|7(handler_method);
      7(handler_method)-->|error track|5(fail_one);
{% endmermaid %}

## With several handler methods and classes

```ruby
class SomeActionSeveralHandlersErrorClasses < Decouplio::Action
  logic do
    step :step_one
    resq handler_method_one: [ArgumentError, NoMethodError],
         handler_method_two: NotImplementedError
    step :step_two
    fail :fail_one
  end

  def step_one
    ctx[:step_one] = c.lambda_for_step_one.call
  end

  def step_two
    ctx[:step_two] = 'Success'
  end

  def fail_one
    ctx[:fail_one] = 'Failure'
  end

  def handler_method_one(error)
    ctx[:error] = error.message
  end

  def handler_method_two(error)
    ctx[:error] = error.message
  end
end

success_action = SomeActionSeveralHandlersErrorClasses.call(
  lambda_for_step_one: -> { true }
)
failure_action = SomeActionSeveralHandlersErrorClasses.call(
  lambda_for_step_one: -> { false }
)
argument_error_action = SomeActionSeveralHandlersErrorClasses.call(
  lambda_for_step_one: -> { raise ArgumentError, 'Argument error message' }
)
no_method_error_action = SomeActionSeveralHandlersErrorClasses.call(
  lambda_for_step_one: -> { raise NoMethodError, 'NoMethodError error message' }
)
no_implemented_error_action = SomeActionSeveralHandlersErrorClasses.call(
  lambda_for_step_one: -> { raise NotImplementedError, 'NotImplementedError error message' }
)

success_action # =>
# Result: success
# RailwayFlow:
#   step_one -> step_two
# Context:
#   :lambda_for_step_one => #<Proc:0x000055e5d6d61d68 resq/resq_with_mapping.rb:102 (lambda)>
#   :step_one => true
#   :step_two => "Success"
# Status: NONE
# Errors:
#   NONE

failure_action # =>
# Result: failure
# RailwayFlow:
#   step_one -> fail_one
# Context:
#   :lambda_for_step_one => #<Proc:0x000055e5d6d61c00 resq/resq_with_mapping.rb:105 (lambda)>
#   :step_one => false
#   :fail_one => "Failure"
# Status: NONE
# Errors:
#   NONE

argument_error_action # =>
# Result: failure
# RailwayFlow:
#   step_one -> handler_method_one -> fail_one
# Context:
#   :lambda_for_step_one => #<Proc:0x000055e5d6d61a98 resq/resq_with_mapping.rb:108 (lambda)>
#   :error => "Argument error message"
#   :fail_one => "Failure"
# Status: NONE
# Errors:
#   NONE

no_method_error_action # =>
# Result: failure
# RailwayFlow:
#   step_one -> handler_method_one -> fail_one
# Context:
#   :lambda_for_step_one => #<Proc:0x000055e5d6d61868 resq/resq_with_mapping.rb:111 (lambda)>
#   :error => "NoMethodError error message"
#   :fail_one => "Failure"
# Status: NONE
# Errors:
#   NONE

no_implemented_error_action # =>
# Result: failure
# RailwayFlow:
#   step_one -> handler_method_two -> fail_one
# Context:
#   :lambda_for_step_one => #<Proc:0x000055e5d6d614a8 resq/resq_with_mapping.rb:114 (lambda)>
#   :error => "NotImplementedError error message"
#   :fail_one => "Failure"
# Status: NONE
# Errors:
#   NONE
```
{% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|4(finish success);
      2(step_one)-->|failure track|5(fail_one);
      5(fail_one)-->|failure track|6(finish failure);
      2(step_one)-->|ArgumentError|7(handler_method_one);
      2(step_one)-->|NoMethodError|9(handler_method_one);
      2(step_one)-->|NotImplementedError|8(handler_method_two);
      7(handler_method_one)-->|error track|5(fail_one);
      9(handler_method_one)-->|error track|5(fail_one);
      8(handler_method_two)-->|error track|5(fail_one);
{% endmermaid %}
