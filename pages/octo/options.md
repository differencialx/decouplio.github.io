---
layout: default
title: Options
permalink: /options/
parent: Octo
nav_order: 6
---

# Octo options

|Option|Allowed|
|:-|:-:|
|on_success|YES|
|on_failure|YES|
|on_error|YES|
|finish_him|NO|
|if|YES|
|unless|YES|

# Octo block options

Options which can be passed to `on` method for step

|Option|Allowed|
|:-|:-:|
|on_success|YES|
|on_failure|YES|
|on_error|YES|
|finish_him|NO|
|if|NO|
|unless|NO|


**NOTE:** `on` method options take precedence over `octo` step options.
```ruby
  class OctoOptions < Decouplio::Action
    logic do
      octo :octo_name, ctx_key: :octo_key, on_success: :FAIL, on_failure: :PASS, on_error: :PASS, if: :something do

        on :octo_key1, :step_one, on_success: :PASS, on_failure: :FAIL, on_error: :PASS

        on :octo_key2, :step_two, on_success: :finish_him, on_failure: :finish_him, on_error: :finish_him

        on :octo_key3, on_success: :step_two, on_error: :finish_him do
          step :step_one
        end
      end
    end

    def step_one
      ctx[:step_one] = 'Success'
    end

    def step_two
      ctx[:step_two] = 'Success'
    end
  end
```
