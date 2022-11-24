---
layout: default
title: Special constants
permalink: /special constants/
nav_order: 9
---

# Special constants

Decouplio has two special constants `PASS` and `FAIL`. They simply are

```ruby
PASS = true
FAIL = false
```

You can use them inside `step` method as last line to make `step` pass of fail.

```ruby
class SomeAction < Decouplio::Action
  logic do
    step :step_one
  end

  def step_one
    FAIL
  end
end

SomeAction.call #=>
# Result: failure
# RailwayFlow:
#   step_one
# Context:
#   Empty
# Status: NONE
# Errors:
#   NONE
```
