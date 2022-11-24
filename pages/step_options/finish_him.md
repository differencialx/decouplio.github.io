---
layout: default
title: finish_him
permalink: /finish_him/
parent: Step options
nav_order: 4
---

# finish_him

Stops action execution. `finish_him` has different option values for different steps, see table below.

|Step type/Available values|`:on_success`|`:on_failure`|`:on_error`|`true`|
|:-|:-:|:-:|:-:|:-:|
|step|YES|YES|YES|NO|
|fail|YES|YES|YES|YES - will stop action execution anyway|
|pass|YES|YES|YES|YES - will stop action execution anyway|
|wrap|YES|YES|YES|NO|
|octo - not allowed|NO|NO|NO|NO|


```ruby
# ...
logic do
  step :step_one, finish_him: :on_success # will stop action execution
  step :step_two
end

def step_one
  true
end
```

```ruby
# ...
logic do
  step :step_one, finish_him: :on_failure # will stop action execution
  step :step_two
  fail :fail_one
end

def step_one
  false
end
```

```ruby
# ...
logic do
  step :step_one, finish_him: :on_error # will stop action execution
  step :step_two
  fail :fail_one
end

def step_one
  raise 'Something went wrong'
end
```

```ruby
# ...
logic do
  step :step_one
  pass :pass_one, finish_him: :true
  fail :fail_one, finish_him: :true

  step :final
  fail :fail_final
end

def step_one
  [true, false].sample
end

def fail_one
  # doesn't matter what value will be returned by step method, action executions will be stopped
end

def pass_one
  # doesn't matter what value will be returned by step method, action executions will be stopped
end
```
