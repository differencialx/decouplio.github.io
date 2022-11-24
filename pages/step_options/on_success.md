---
layout: default
title: on_success
permalink: /on_success/
parent: Step options
nav_order: 1
---

# on_success

If step result is truthy value then defined option value will be performed

|Allowed values|Behavior|
|:-|:-|
|:PASS|performs next success track step|
|:FAIL|performs next failure track step|
|:finish_him|stops action execution|
|symbol of the next step|performs defined step, no matter on which track it is.|

```ruby
# ...
logic do
  step :step_one, on_success: :PASS # will perform step_two
  step :step_two
  fail :fail_one
end

def step_one
  true
end
# ...
```
```ruby
# ...
logic do
  step :step_one, on_success: :FAIL # will perform fail_one
  step :step_two
  fail :fail_one
end

def step_one
  true
end
# ...
```
```ruby
# ...
logic do
  step :step_one, on_success: :finish_him # will stop action execution
  step :step_two
  fail :fail_one
end

def step_one
  true
end
# ...
```
```ruby
# ...
logic do
  step :step_one, on_success: :fail_two # will perform fail_two
  step :step_two
  fail :fail_one
  fail :fail_two
end

def step_one
  true
end
# ...
```
