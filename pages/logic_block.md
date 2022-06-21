---
layout: default
title: Logic block
permalink: /logic_block/
nav_order: 2
has_children: true
---

## Logic block

It's just a block witch contains flow logic

```ruby
require 'decouplio'

class SomeAction < Decouplio::Action
  logic do
    # define your logic here
  end
end
```

What to put inside `logic` block?

See below:
