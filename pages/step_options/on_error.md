---
layout: default
title: on_error
permalink: /on_error/
parent: Step options
nav_order: 3
---

# on_error

Will be performed only in pair with [resq]() step. When step raises an exception then specified `on_error` option will be performed, only after resq handler method execution.

|Allowed values|Behavior|
|:-|:-|
|:PASS|performs next success track step|
|:FAIL|performs next failure track step|
|:finish_him|stops action execution|
|symbol of the next step|performs defined step, no matter on which track it is.|

```ruby
# ...
logic do
  step :step_one, on_error: :PASS # will perform step_two
  resq :handle_step_one
  step :step_two
  fail :fail_one
end

def step_one
  raise 'Something went wrong'
end

def handle_step_one(error)
  # handle an error
end
# ...
```
```ruby
# ...
logic do
  step :step_one, on_error: :FAIL # will perform fail_one
  resq :handle_step_one
  step :step_two
  fail :fail_one
end

def step_one
  raise 'Something went wrong'
end

def handle_step_one(error)
  # handle an error
end
# ...
```
```ruby
# ...
logic do
  step :step_one, on_error: :finish_him # will stop action execution
  resq :handle_step_one
  step :step_two
  fail :fail_one
end

def step_one
  raise 'Something went wrong'
end

def handle_step_one(error)
  # handle an error
end
# ...
```
```ruby
# ...
logic do
  step :step_one, on_error: :fail_two # will perform fail_two
  resq :handle_step_one
  step :step_two
  fail :fail_one
  fail :fail_two
end

def step_one
  raise 'Something went wrong'
end

def handle_step_one(error)
  # handle an error
end
# ...
```
