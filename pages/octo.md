---
layout: default
title: Octo
permalink: /octo/
has_children: true
nav_order: 5
---

# Octo (experimental)

It's a step type which helps to implement strategy pattern.

## Signature

```ruby
octo(octo_name, (ctx_key:|method:), **step_options) do
  # Octo block
  on(octo_key, step_to_perform=nil, **step_options, &block)
end
```

## Behavior

- Octo executes different flows depending on specified value.
- You have two options to set value for octo. By [**ctx_key**](https://differencialx.github.io/decouplio.github.io/octo/octo_by_ctx_key/) and [**method**](https://differencialx.github.io/decouplio.github.io/octo/octo_by_method/).
- `ctx_key` and `method` options are controversial, so you can use only one of them.
- with `ctx_key` you can specify the key inside action context
- with `method` you can specify method name symbol, which will be called to retrieve `octo_key` value.
- step options from `on` definition will override options from `octo` step options
