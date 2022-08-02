---
layout: default
title: Pass
permalink: /pass/
parent: Logic block
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

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

{% highlight ruby %}
    require 'decouplio'

    class SomeAction < Decouplio::Action
      logic do
        pass :pass_one
        step :step_two
        fail :fail_one
      end

      def pass_one(param_for_pass:, **)
        ctx[:pass_one] = param_for_pass
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def fail_one(**)
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
  {% endhighlight %}

{% mermaid %}
    flowchart LR;
        1(start)-->2(pass_one success);
        1(start)-->3(pass_one failure);
        2(pass_one success)-->|success track|4(step_two);
        3(pass_one failure)-->|success track|4(step_two);
        4(step_two)-->|success track|5(finish_success)
{% endmermaid %}

</p>
</details>

***

## Options

### on_error: any value allowed for on_success or on_failure
Behaves in the same way as [on_error for step](/decouplio.github.io/step/#on_error-any-value-allowed-for-on_success-or-on_failure)

***

### if: condition method name
Can be used in case if for some reason step shouldn't be executed

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

{% highlight ruby %}
    require 'decouplio'

    class SomeActionIfCondition < Decouplio::Action
      logic do
        step :step_one
        pass :pass_one, if: :some_condition?
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def pass_one(**)
        ctx[:pass_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def some_condition?(condition_param:, **)
        condition_param
      end
    end

    condition_positive = SomeActionIfCondition.call(condition_param: true)
    condition_negative = SomeActionIfCondition.call(condition_param: false)

    condition_positive # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> pass_one -> step_two

    # Context:
    #   :condition_param => true
    #   :step_one => "Success"
    #   :pass_one => "Success"
    #   :step_two => "Success"

    # Status: NONE

    # Errors:
    #   NONE


    condition_negative # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> step_two

    # Context:
    #   :condition_param => false
    #   :step_one => "Success"
    #   :step_two => "Success"

    # Status: NONE

    # Errors:
    #   NONE
  {% endhighlight %}

{% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|condition positive|3(pass_one);
      3(pass_one)-->|success track|4(step_two);
      2(step_one)-->|condition negative|4(step_two);
      4(step_two)-->|success track|5(finish_success);
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

    class SomeActionUnlessCondition < Decouplio::Action
      logic do
        step :step_one
        pass :pass_one, unless: :some_condition?
        step :step_two
      end

      def step_one(**)
        ctx[:step_one] = 'Success'
      end

      def pass_one(**)
        ctx[:pass_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def some_condition?(condition_param:, **)
        condition_param
      end
    end

    condition_positive = SomeActionUnlessCondition.call(condition_param: false)
    condition_negative = SomeActionUnlessCondition.call(condition_param: true)

    condition_positive # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> pass_one -> step_two

    # Context:
    #   :condition_param => false
    #   :step_one => "Success"
    #   :pass_one => "Success"
    #   :step_two => "Success"

    # Status: NONE

    # Errors:
    #   NONE

    condition_negative # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> step_two

    # Context:
    #   :condition_param => true
    #   :step_one => "Success"
    #   :step_two => "Success"

    # Status: NONE

    # Errors:
    #   NONE
  {% endhighlight %}

{% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|condition positive|3(pass_one);
      3(pass_one)-->|success track|4(step_two);
      2(step_one)-->|condition negative|4(step_two);
      4(step_two)-->|success track|5(finish_success);
{% endmermaid %}
</p>
</details>

***

### finish_him: true

Can be used in case if for some reason step shouldn't be executed

<details><summary><b>EXAMPLE (CLICK ME)</b></summary>
<p>

{% highlight ruby %}
    require 'decouplio'

    class SomeActionFinishHim < Decouplio::Action
      logic do
        step :step_one, on_success: :step_two, on_failure: :pass_one
        pass :pass_one, finish_him: true
        step :step_two
        step :step_three
      end

      def step_one(param_for_step:, **)
        ctx[:step_one] = param_for_step
      end

      def pass_one(**)
        ctx[:pass_one] = 'Success'
      end

      def step_two(**)
        ctx[:step_two] = 'Success'
      end

      def step_three(**)
        ctx[:step_three] = 'Success'
      end
    end

    success_track = SomeActionFinishHim.call(param_for_step: true)
    failure_track = SomeActionFinishHim.call(param_for_step: false)

    success_track # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> step_two -> step_three

    # Context:
    #   :param_for_step => true
    #   :step_one => true
    #   :step_two => "Success"
    #   :step_three => "Success"

    # Status: NONE

    # Errors:
    #   NONE

    failure_track # =>
    # Result: success

    # RailwayFlow:
    #   step_one -> pass_one

    # Context:
    #   :param_for_step => false
    #   :step_one => false
    #   :pass_one => "Success"

    # Status: NONE

    # Errors:
    #   NONE
  {% endhighlight %}

{% mermaid %}
  flowchart LR;
      1(start)-->2(step_one);
      2(step_one)-->|success track|3(step_two);
      3(step_two)-->|success track|4(step_three);
      2(step_one)-->|failure track|5(pass_one);
      4(step_three)-->|success track|6(finish success);
      5(pass_one)-->|success track|6(finish success);
{% endmermaid %}
</p>
</details>

***
