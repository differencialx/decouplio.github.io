---
layout: default
title: Wrap
permalink: /wrap/
has_children: true
nav_order: 4
---

# Wrap

`wrap` is the type of step, that behaves like `step`, but can wrap several steps with block to make some before/after actions or to [rescue an error](/decouplio.github.io/resq) for several steps.

## Signature

```ruby
wrap(wrap_name, **options) do
  # steps to wrap
end
```

## Behavior

- all steps inside `wrap` step will be perceived as [inner action](/decouplio.github.io/inner_action). So depending on inner action result the `wrap` step will be moved to success or failure track.
- All step options for `step` can be applied for `wrap`
