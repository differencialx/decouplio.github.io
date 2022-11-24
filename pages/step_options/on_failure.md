---
layout: default
title: on_failure
permalink: /on_failure/
parent: Step options
nav_order: 2
---

# on_failure

If step result is falsy value then defined option value will be performed

|Allowed values|Behavior|
|:-|:-|
|:PASS|performs next success track step|
|:FAIL|performs next failure track step|
|:finish_him|stops action execution|
|symbol of the next step|performs defined step, no matter on which track it is.|

```ruby
# ...
logic do
  step :step_one, on_failure: :PASS # will perform step_two
  step :step_two
  fail :fail_one
end

def step_one
  false
end
# ...
```
```ruby
# ...
logic do
  step :step_one, on_failure: :FAIL # will perform fail_one
  step :step_two
  fail :fail_one
end

def step_one
  false
end
# ...
```
```ruby
# ...
logic do
  step :step_one, on_failure: :finish_him # will stop action execution
  step :step_two
  fail :fail_one
end

def step_one
  false
end
# ...
```
```ruby
# ...
logic do
  step :step_one, on_failure: :fail_two # will perform fail_two
  step :step_two
  fail :fail_one
  fail :fail_two
end

def step_one
  false
end
# ...
```
