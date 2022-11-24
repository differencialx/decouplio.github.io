---
layout: default
title: Custom MetaStore
permalink: /custom_metastore/
parent: Meta store
nav_order: 2
---

# Custom MetaStore

You always can define your own meta store, which will suit for you.
Just create new class
AND
Set it for action using `meta_store_class` method

**NOTE: To avoid setting your custom `meta_store` for all action, you can create a base class and set it there and just inherit your action from it.**

```ruby
class CustomMetaStore
  attr_reader :whatever

  def initialize
    @whatever = []
  end

  def add_whatever(element)
    @whatever << element
  end

  def to_s
    <<~METASTORE
      Whatever:
        #{@whatever.inspect}
    METASTORE
  end
end

class BaseCustomMetaStore < Decouplio::Action
  meta_store_class CustomMetaStore
end

class CustomMetaStoreAction < BaseCustomMetaStore
  logic do
    step :add_whatever
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
#   NONE
# Whatever:
#   [42, "Whatever"]
```
