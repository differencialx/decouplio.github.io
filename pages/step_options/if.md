---
layout: default
title: if/unless
permalink: /if_unless/
parent: Step options
nav_order: 5
---

# if/unless

Can be used if you need to perform step conditionally

`if/unless` is allowed for `step`, `fail`, `pass`, `wrap`, `octo`

```ruby
# ...
logic do
  step :step_one, if: :some_condition? # step will be executed if some_condition? method returns truthy value
  step :step_two, unless: :another_condition? # step will be executed unless another_condition? method returns falsy value
  step :step_three
end

def step_one
  true
end

def step_two
  true
end

def some_condition?
  c.some_value == 'some_value'
end

def another_condition?
  c.another_value == 'another_value'
end
# ...
```
