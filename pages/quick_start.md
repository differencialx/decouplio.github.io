---
layout: default
title: Quick start
permalink: /quick_start/
nav_order: 1
---

## Quick start

### Installation

Regular installation
```
gem install decouplio
```

Gemfile
```ruby
gem 'decouplio'
```

### Usage

All you need to do is to create new class and inherit it from `Decouplio::Action`, define your action logic and implement methods.

```ruby
require 'decouplio'

class ProcessNumber < Decouplio::Action
  logic do
    step :multiply
    step :divide
  end

  def multiply(number:, multiplier:, **)
    ctx[:result] = number * multiplier
  end

  def divide(result:, divider:, **)
    ctx[:result] = result / divider
  end
end

action = ProcessNumber.call(number: 5, multiplier: 4, divider: 10) # =>
# Result: success

# Railway Flow:
#   multiply -> divide

# Context:
#   {:number=>5, :multiplier=>4, :divider=>10, :result=>2}

# Errors:
#   {}

action[:number] # => 5
action[:multiplier] # => 4
action[:divider] # => 10
action[:result] # => 2

action.success? # => true
action.failure? # => false

action.railway_flow # => [:multiply, :divide]
```
