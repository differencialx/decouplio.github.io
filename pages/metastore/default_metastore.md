---
layout: default
title: Default MetaStore
permalink: /default_metastore/
parent: Meta store
nav_order: 1
---

# Default MetaStore

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
Also `meta_store` will be passed as a second argument into Service as a step.

`Decouplio::DefaultMetaStore` implements basic three basic methods
- `add_error` - adds error to `meta_store`
- `status=` - sets status or action. It can be used to make a decision what should be done next, as `success` or `failure` action result is not enough sometimes.
- `to_s` - this method should be implemented if you want to have good looking console output of action, otherwise it will be printed as default object.

```ruby
require 'decouplio'

class SomeAction < Decouplio::Action
  logic do
    step :step_one
    fail :fail_one
  end

  def step_one(**)
    FAIL
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
# Context: NONE
# Status: step_one_failure
# Errors:
#   :something_went_wrong => ["Something went wrong"]

action.ms.errors # =>
# {:something_went_wrong=>["Something went wrong"]}

action.ms.status # =>
# step_one_failure
```
