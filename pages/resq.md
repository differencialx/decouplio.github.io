---
layout: default
title: Resq
permalink: /resq/
has_children: true
nav_order: 6
---

# Resq

Step type which can be used to handle errors raised during step invocation.

## Signature

```ruby
resq(handler_method=nil, **options)
```

## Behavior

- When `resq` step is defined it will catch exceptions raised from step defined above.
- After `resq` performed handler method, next failure track step will be performed. You can override this behavior using `on_error` option for step.
***
