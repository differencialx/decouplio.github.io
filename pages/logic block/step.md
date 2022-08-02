---
layout: default
title: Step
permalink: /step/
parent: Logic block
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

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  {% highlight ruby %}
    require 'decouplio'

    class SomeAction < Decouplio::Action
      logic do
        step :step_one
        fail :fail_one
        step :step_two
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
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
  {% endhighlight %}

  {% mermaid %}
    flowchart LR;
        A(start)-->B(step_one);
        B(step_one)-->|success track|C(step_two);
        B(step_one)-->|failure track|D(fail_one);
        C(step_two)-->|success track|E(finish_success);
        D(fail_one)-->|failure track|F(finish_failure);
  {% endmermaid %}

</p>
</details>

***

## Options

### on_success:

|Allowed values|Description|
|-|-|
|:finish_him|action stops execution if `step` method returns truthy value|
|symbol with next step name|step with specified symbol name performs if step method returns truthy value|
|:PASS|will direct execution flow to nearest success track step. If current step is the last step when action will finish as `success`|
|:FAIL|will direct execution flow to nearest failure track step. If current step is the last step when action will finish as `failure`|

### on_success: :finish_him

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  {% highlight ruby %}
    require 'decouplio'

    class SomeActionOnSuccessFinishHim < Decouplio::Action
      logic do
        step :step_one, on_success: :finish_him
        fail :fail_one
        step :step_two
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:result] = 'Success'
      end
    end

    success_action = SomeActionOnSuccessFinishHim.call(param_for_step_one: true)
    failure_action = SomeActionOnSuccessFinishHim.call(param_for_step_one: false)
    success_action # =>
    # Result: success

    # RailwayFlow:
    #   step_one

    # Context:
    #   :param_for_step_one => true

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
  {% endhighlight %}

  {% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(finish_success);
      2(step_one)-->|failure track|4(fail_one);
      4(fail_one)-->|failure track|5(finish_failure);
  {% endmermaid %}
</p>
</details>

***

### on_success: next success track step

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  {% highlight ruby %}
    require 'decouplio'

    class SomeActionOnSuccessToSuccessTrack < Decouplio::Action
      logic do
        step :step_one, on_success: :step_three
        fail :fail_one
        step :step_two
        step :step_three
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def step_three(**)
        ctx[:result] = 'Result'
      end
    end

    success_action = SomeActionOnSuccessToSuccessTrack.call(param_for_step_one: true)
    failure_action = SomeActionOnSuccessToSuccessTrack.call(param_for_step_one: false)
    success_action # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> step_three

    # Context:
    #   :param_for_step_one => true
    #   :result => "Result"

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
  {% endhighlight %}

  {% mermaid %}
  flowchart LR;
      A(start)-->B(step_one);
      B(step_one)-->|success track|C(step_three);
      B(step_one)-->|failure track|D(fail_one);
      C(step_three)-->|success track|E(finish_success);
      D(fail_one)-->|failure track|F(finish_failure);
  {% endmermaid %}

</p>
</details>

***

### on_success: next failure track step

Can be used if for some reason you need to jump to fail step

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  {% highlight ruby %}
    require 'decouplio'

    class SomeActionOnSuccessToFailureTrack < Decouplio::Action
      logic do
        step :step_one, on_success: :fail_two
        fail :fail_one
        step :step_two
        step :step_three
        fail :fail_two
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def step_three(**)
        ctx[:result] = 'Result'
      end

      def fail_two(**)
        ctx[:fail_two] = 'Failure'
      end
    end

    success_action = SomeActionOnSuccessToFailureTrack.call(param_for_step_one: true)
    failure_action = SomeActionOnSuccessToFailureTrack.call(param_for_step_one: false)
    success_action # =>
    # Result: failure

    # RailwayFlow:
    #   step_one -> fail_two

    # Context:
    #   :param_for_step_one => true
    #   :fail_two => "Failure"

    # Status: NONE

    # Errors:
    #   NONE


    failure_action # =>
    # Result: failure

    # RailwayFlow:
    #   step_one -> fail_one -> fail_two

    # Context:
    #   :param_for_step_one => false
    #   :action_failed => true
    #   :fail_two => "Failure"

    # Status: NONE

    # Errors:
    #   NONE
  {% endhighlight %}

  {% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(fail_two);
      2(step_one)-->|failure track|4(fail_one);
      4(fail_one)-->|failure track|3(fail_two);
      3(fail_two)-->|failure track|5(finish_failure);
  {% endmermaid %}

</p>
</details>

***

### on_success: :PASS
It will perform like regular `step`, just move to next success track step.

### on_success: :FAIL
It will perform next failure track step OR finish action as `failure` in case if step is the last step.

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  {% highlight ruby %}
    require 'decouplio'

    class SomeActionOnSuccessFail < Decouplio::Action
      logic do
        step :step_one
        step :step_two, on_success: :FAIL
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def step_two(step_two_param:, **)
        ctx[:step_two] = step_two_param
      end
    end

    success_action = SomeActionOnSuccessFail.call(step_two_param: true)
    failure_action = SomeActionOnSuccessFail.call(step_two_param: false)

    success_action # =>
    # Result: failure

    # RailwayFlow:
    #   step_one -> step_two

    # Context:
    #   :step_two_param => true
    #   :step_one => "Success"
    #   :step_two => true

    # Status: NONE

    # Errors:
    #   NONE


    failure_action # =>
    # Result: failure

    # RailwayFlow:
    #   step_one -> step_two

    # Context:
    #   :step_two_param => false
    #   :step_one => "Success"
    #   :step_two => false

    # Status: NONE

    # Errors:
    #   NONE
  {% endhighlight %}

  {% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|4(finish_failure);
      3(step_two)-->|failure track|5(finish_failure);
  {% endmermaid %}
</p>
</details>

***


### on_failure:

|Allowed values|Description|
|-|-|
|:finish_him|action stops execution if `step` method returns falsy value|
|symbol with next step name|step with specified symbol name performs if step method returns falsy value|
|:PASS|will direct execution flow to nearest success track step. If current step is the last step when action will finish as `success`|
|:FAIL|will direct execution flow to nearest failure track step. If current step is the last step when action will finish as `failure`|

### on_failure: :finish_him

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  {% highlight ruby %}
    require 'decouplio'

    class SomeActionOnFailureFinishHim < Decouplio::Action
      logic do
        step :step_one, on_failure: :finish_him
        fail :fail_one
        step :step_two
        fail :fail_two
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:result] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'failure'
      end
    end

    success_action = SomeActionOnFailureFinishHim.call(param_for_step_one: true)
    failure_action = SomeActionOnFailureFinishHim.call(param_for_step_one: false)
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
    #   step_one

    # Context:
    #   :param_for_step_one => false

    # Status: NONE

    # Errors:
    #   NONE
  {% endhighlight %}

  {% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|5(finish_success);
      2(step_one)-->|failure track|4(finish_failure);
  {% endmermaid %}
</p>
</details>

***

### on_failure: next success track step

Can be used in case if you need to come back to success track

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  {% highlight ruby %}
    require 'decouplio'

    class SomeActionOnFailureToSuccessTrack < Decouplio::Action
      logic do
        step :step_one, on_failure: :step_three
        fail :fail_one
        step :step_two
        fail :fail_two
        step :step_three
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:result] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'failure'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end
    end

    success_action = SomeActionOnFailureToSuccessTrack.call(param_for_step_one: true)
    failure_action = SomeActionOnFailureToSuccessTrack.call(param_for_step_one: false)
    success_action # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> step_two -> step_three

    # Context:
    #   :param_for_step_one => true
    #   :result => "Success"
    #   :step_three => "Success"

    # Status: NONE

    # Errors:
    #   NONE


    failure_action # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> step_three

    # Context:
    #   :param_for_step_one => false
    #   :step_three => "Success"

    # Status: NONE

    # Errors:
    #   NONE
  {% endhighlight %}

  {% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|4(step_three);
      4(step_three)-->|success track|5(finish_success);
      2(step_one)-->|failure track|4(step_three);
  {% endmermaid %}
</p>
</details>

***

### on_failure: next failure track step

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  {% highlight ruby %}
    require 'decouplio'

    class SomeActionOnFailureToFailureTrack < Decouplio::Action
      logic do
        step :step_one, on_failure: :fail_two
        fail :fail_one
        step :step_two
        fail :fail_two
        step :step_three
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:result] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'failure'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end
    end

    success_action = SomeActionOnFailureToFailureTrack.call(param_for_step_one: true)
    failure_action = SomeActionOnFailureToFailureTrack.call(param_for_step_one: false)
    success_action # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> step_two -> step_three

    # Context:
    #   :param_for_step_one => true
    #   :result => "Success"
    #   :step_three => "Success"

    # Status: NONE

    # Errors:
    #   NONE


    failure_action # =>
    # Result: failure

    # RailwayFlow:
    #   step_one -> fail_two

    # Context:
    #   :param_for_step_one => false
    #   :fail_two => "failure"

    # Status: NONE

    # Errors:
    #   NONE
  {% endhighlight %}

  {% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|4(step_three);
      4(step_three)-->|success track|5(finish_success);
      2(step_one)-->|failure track|6(fail_two);
      6(fail_two)-->|failure track|7(finish_failure);
  {% endmermaid %}
</p>
</details>

***

### on_failure: :PASS
It will perform next success track step OR finish action as `success` if it's the last step.

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  {% highlight ruby %}
    require 'decouplio'

    class SomeActionOnFailurePass < Decouplio::Action
      logic do
        step :step_one
        step :step_two, on_failure: :PASS
      end

      def step_one(**)
        ctx[:step_one] = true
      end

      def step_two(step_two_param:, **)
        ctx[:step_two] = step_two_param
      end
    end


    success_action = SomeActionOnFailurePass.call(step_two_param: true)
    failure_action = SomeActionOnFailurePass.call(step_two_param: false)

    success_action # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> step_two

    # Context:
    #   :step_two_param => true
    #   :step_one => true
    #   :step_two => true

    # Status: NONE

    # Errors:
    #   NONE


    failure_action # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> step_two

    # Context:
    #   :step_two_param => false
    #   :step_one => true
    #   :step_two => false

    # Status: NONE

    # Errors:
    #   NONE
  {% endhighlight %}

  {% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|4(finish_success);
      3(step_two)-->|failure track|5(finish_success);
  {% endmermaid %}
</p>
</details>

***


### on_failure: :FAIL
It will perform like regular `step`, just move to next failure track step.

***

### on_error: any value allowed for on_success or on_failure
`on_error` option is used in case when [resq step](/decouplio.github.io/resq) is applied to `step, fail, pass, wrap`.
If step raises an error then handler method will be executed and after execution flow will directed to value you specified for `on_error` option.

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  {% highlight ruby %}
    require 'decouplio'

    class SomeActionOnErrorNextSuccessTrackStep < Decouplio::Action
      logic do
        step :step_one, on_error: :step_three
        resq handle_step_one: ArgumentError
        fail :fail_one
        step :step_two
        step :step_three
      end

      def step_one(step_one_lambda:, **)
        ctx[:step_one] = step_one_lambda.call
      end

      def fail_one(**)
        ctx[:fail_one] = 'Failure'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def handle_step_one(error, **)
        ctx[:handle_step_one] = error.message
      end
    end

    success_action = SomeActionOnErrorNextSuccessTrackStep.call(
      step_one_lambda: -> { true }
    )
    failed_action = SomeActionOnErrorNextSuccessTrackStep.call(
      step_one_lambda: -> { false }
    )
    erroneous_action = SomeActionOnErrorNextSuccessTrackStep.call(
      step_one_lambda: -> { raise ArgumentError, 'Some message' }
    )

    success_action # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> step_two -> step_three

    # Context:
    #   :step_one_lambda => #<Proc:0x0000565032135d98 step.rb:742 (lambda)>
    #   :step_one => true
    #   :step_two => "Success"
    #   :step_three => "Success"

    # Status: NONE

    # Errors:
    #   NONE


    failed_action # =>
    # Result: failure

    # RailwayFlow:
    #   step_one -> fail_one

    # Context:
    #   :step_one_lambda => #<Proc:0x0000565032135938 step.rb:745 (lambda)>
    #   :step_one => false
    #   :fail_one => "Failure"

    # Status: NONE

    # Errors:
    #   NONE


    erroneous_action # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> handle_step_one -> step_three

    # Context:
    #   :step_one_lambda => #<Proc:0x0000565032135398 step.rb:748 (lambda)>
    #   :handle_step_one => "Some message"
    #   :step_three => "Success"

    # Status: NONE

    # Errors:
    #   NONE
  {% endhighlight %}

  {% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|4(step_three);
      4(step_three)-->|success track|5(finish_success);
      2(step_one)-->|failure track|6(fail_one);
      6(fail_one)-->|failure track|7(finish_failure);
      2(step_one)-->|error track|8(handler_step_one);
      8(handler_step_one)-->|success track|4(step_three);
  {% endmermaid %}
</p>
</details>

***

### if: condition method name
Can be used in case if for some reason step shouldn't be executed

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  {% highlight ruby %}
    require 'decouplio'

    class SomeActionOnIfCondition < Decouplio::Action
      logic do
        step :step_one
        fail :fail_one
        step :step_two
        fail :fail_two
        step :step_three, if: :step_condition?
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:result] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'failure'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def step_condition?(step_condition_param:, **)
        step_condition_param
      end
    end

    condition_positive = SomeActionOnIfCondition.call(
      param_for_step_one: true,
      step_condition_param: true
    )
    condition_negative = SomeActionOnIfCondition.call(
      param_for_step_one: true,
      step_condition_param: false
    )
    condition_positive # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> step_two -> step_three

    # Context:
    #   :param_for_step_one => true
    #   :step_condition_param => true
    #   :result => "Success"
    #   :step_three => "Success"

    # Status: NONE

    # Errors:
    #   NONE


    condition_negative # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> step_two

    # Context:
    #   :param_for_step_one => true
    #   :step_condition_param => false
    #   :result => "Success"

    # Status: NONE

    # Errors:
    #   NONE
  {% endhighlight %}

  {% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|condition positive|3(step_two);
      3(step_two)-->|condition positive|4(step_three);
      4(step_three)-->|condition positive|5(finish_success);
      2(step_one)-->|condition negative|6(step_two);
      6(step_two)-->|condition negative|7(finish_success);
  {% endmermaid %}
</p>
</details>

***

### unless: condition method name
Can be used in case if for some reason step shouldn't be executed

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

  {% highlight ruby %}
    require 'decouplio'

    class SomeActionOnUnlessCondition < Decouplio::Action
      logic do
        step :step_one
        fail :fail_one
        step :step_two
        fail :fail_two
        step :step_three, unless: :step_condition?
      end

      def step_one(param_for_step_one:, **)
        param_for_step_one
      end

      def fail_one(**)
        ctx[:action_failed] = true
      end

      def step_two(**)
        ctx[:result] = 'Success'
      end

      def fail_two(**)
        ctx[:fail_two] = 'failure'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end

      def step_condition?(step_condition_param:, **)
        step_condition_param
      end
    end

    condition_positive = SomeActionOnUnlessCondition.call(
      param_for_step_one: true,
      step_condition_param: true
    )
    condition_negative = SomeActionOnUnlessCondition.call(
      param_for_step_one: true,
      step_condition_param: false
    )
    condition_positive # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> step_two

    # Context:
    #   :param_for_step_one => true
    #   :step_condition_param => true
    #   :result => "Success"

    # Status: NONE

    # Errors:
    #   NONE


    condition_negative # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> step_two -> step_three

    # Context:
    #   :param_for_step_one => true
    #   :step_condition_param => false
    #   :result => "Success"
    #   :step_three => "Success"

    # Status: NONE

    # Errors:
    #   NONE
  {% endhighlight %}

  {% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|condition positive|3(step_two);
      3(step_two)-->|condition positive|4(finish_success);
      2(step_one)-->|condition negative|5(step_two);
      5(step_two)-->|condition negative|6(step_three);
      6(step_three)-->|condition negative|7(finish_success);
  {% endmermaid %}
</p>
</details>

***

### finish_him: :on_success
The same behavior as for `on_success: :finish_him`

***

### finish_him: :on_failure
The same behavior as for `on_failure: :finish_him`

***

### finish_him: :on_error
The same behavior as for `on_error: :finish_him`

***
