---
layout: default
title: Benchmarks
permalink: /benchmarks/
nav_order: 12
search_exclude: true
---

## Benchmarks



[benchmark sources](https://github.com/differencialx/decouplio/tree/master/benchmarks)

```
Simple steps
Warming up --------------------------------------
                PORO    69.834k i/100ms
         Trailblazer     1.017k i/100ms
          Interactor     1.499k i/100ms
           Decouplio    28.432k i/100ms
Calculating -------------------------------------
                PORO    740.448k (± 0.4%) i/s -      3.771M in   5.094283s
         Trailblazer     10.294k (± 0.8%) i/s -     51.867k in   5.043984s
          Interactor     15.466k (± 1.7%) i/s -     77.948k in   5.059536s
           Decouplio    295.773k (± 0.8%) i/s -      1.478M in   5.003660s
                   with 95.0% confidence

Comparison:
                PORO:   740448.0 i/s
           Decouplio:   295772.7 i/s - 2.50x  (± 0.02) slower
          Interactor:    15465.9 i/s - 47.88x  (± 0.83) slower
         Trailblazer:    10294.5 i/s - 71.93x  (± 0.67) slower
                   with 95.0% confidence
```

```
Callable steps
Warming up --------------------------------------
                PORO    34.512k i/100ms
   Trailblazer Macro     1.012k i/100ms
          Interactor   968.000  i/100ms
           Decouplio    27.040k i/100ms
Calculating -------------------------------------
                PORO    350.455k (± 0.7%) i/s -      1.760M in   5.025818s
   Trailblazer Macro     10.343k (± 1.1%) i/s -     51.612k in   5.000710s
          Interactor      9.977k (± 1.9%) i/s -     50.336k in   5.069236s
           Decouplio    270.164k (± 1.2%) i/s -      1.352M in   5.016751s
                   with 95.0% confidence

Comparison:
                PORO:   350454.8 i/s
           Decouplio:   270164.2 i/s - 1.30x  (± 0.02) slower
   Trailblazer Macro:    10343.3 i/s - 33.88x  (± 0.45) slower
          Interactor:     9977.3 i/s - 35.12x  (± 0.70) slower
                   with 95.0% confidence

```
