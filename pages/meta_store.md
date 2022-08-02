---
layout: default
title: Meta store
permalink: /meta_store/
nav_order: 4
---

# Meta store

It's an object to persist meta data about action, like errors or some status. By default `Decouplio::DefaultMetaStore` is used for `Decouplio::Action`

This is how `DefaultMetaStore` looks like.
```ruby
module Decouplio
  class DefaultMetaStore
    attr_accessor :status
    attr_reader :errors

    def initialize
      @errors = {}
      @status = nil
    end

    def add_error(key, messages)
      @errors.store(
        key,
        (@errors[key] || []) + [messages].flatten
      )
    end

    def to_s
      <<~METASTORE
        Status: #{@status || 'NONE'}

        Errors:
          #{errors_string}
      METASTORE
    end

    private

    def errors_string
      return 'NONE' if @errors.empty?

      @errors.map do |k, v|
        "#{k.inspect} => #{v.inspect}"
      end.join("\n  ")
    end
  end
end
```

## How to use
For each new action call new `meta_store` will be initialized. You can access `meta_store` by calling `ms` method inside step's methods.
Also `meta_store` will be passed as a kwarg into Service as a step.
`Decouplio::DefaultMetaStore` implements basic three basic methods
- `add_error` - adds error to `meta_store`
- `status=` - sets status or action. It can be used to make a decision what should be done next, as `success` or `failure` action result is not enough sometimes.
- `to_s` - this method should me implemented if you want to have good looking console output of action, otherwise it will be printed as default object.

```ruby
require 'decouplio'

class SomeAction < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one
  end

  def step_one(**)
    false
  end

  def fail_one(**)
    ms.status = :step_one_failure
    ms.add_error(:something_went_wrong, 'Something went wrong')
  end
end

action = SomeAction.call

action # =>
# Result: failure

# RailwayFlow:
#   step_one -> fail_one

# Context:


# Status: step_one_failure

# Errors:
#   :something_went_wrong => ["Something went wrong"]

action.ms.errors # =>
# {:something_went_wrong=>["Something went wrong"]}

action.ms.status # =>
# step_one_failure
```

## Behavior

 - In case if inner action is used, then meta_store from parent action will be used inside inner action.

## Custom meta store

You always can define your own meta store, which will suits for you.
Just create new class
AND
Set it for action using `meta_store_class` method

**NOTE: To avoid setting your custom `meta_store` for all action, you can create a base class and set it there and just inherit your action from it.**

```ruby
class CustomMetaStore
  attr_accessor :status
  attr_reader :errors, :whatever

  def initialize
    @errors = {}
    @status = nil
    @whatever = []
  end

  def add_error(key, messages)
    @errors.store(
      key,
      (@errors[key] || []) + [messages].flatten
    )
  end

  def add_whatever(element)
    @whatever << element
  end

  def to_s
    <<~METASTORE
      Status: #{@status || 'NONE'}

      Errors:
        #{errors_string}

      Whatever:
        #{@whatever.inspect}
    METASTORE
  end

  private

  def errors_string
    return 'NONE' if @errors.empty?

    @errors.map do |k, v|
      "#{k.inspect} => #{v.inspect}"
    end.join("\n  ")
  end
end

class CustomMetaStoreAction < Decouplio::Action
  meta_store_class CustomMetaStore

  logic do
    step :add_meta_status
    step :add_meta_error
    step :add_whatever
  end

  def add_meta_status(**)
    ms.status = :custom_status
  end

  def add_meta_error(**)
    ms.add_error(:custom_error, 'Custom error')
  end

  def add_whatever(**)
    ms.add_whatever(42)
    ms.add_whatever('Whatever')
  end
end

result = CustomMetaStoreAction.call

result
# Result: success

# RailwayFlow:
#   add_meta_status -> add_meta_error -> add_whatever

# Context:


# Status: custom_status

# Errors:
#   :custom_error => ["Custom error"]

# Whatever:
#   [42, "Whatever"]

```
***
