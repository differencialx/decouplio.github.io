---
layout: default
title: Benchmarks
permalink: /benchmarks/
nav_order: 12
search_exclude: true
---

## Benchmarks



[benchmark sources]()

```
Simple steps
Warming up --------------------------------------
                PORO    74.786k i/100ms
         Trailblazer   930.000  i/100ms
          Interactor     1.599k i/100ms
           Decouplio    28.587k i/100ms
Calculating -------------------------------------
                PORO    758.208k (± 0.4%) i/s -      3.814M in   5.031344s
         Trailblazer     10.252k (± 0.9%) i/s -     52.080k in   5.086549s
          Interactor     14.874k (± 2.6%) i/s -     75.153k in   5.103057s
           Decouplio    259.033k (± 2.4%) i/s -      1.286M in   5.003510s
                   with 95.0% confidence

Comparison:
                PORO:   758208.1 i/s
           Decouplio:   259033.0 i/s - 2.93x  (± 0.07) slower
          Interactor:    14874.2 i/s - 50.97x  (± 1.35) slower
         Trailblazer:    10252.2 i/s - 73.95x  (± 0.74) slower
                   with 95.0% confidence

```


```
Callable steps
Warming up --------------------------------------
                PORO    30.407k i/100ms
   Trailblazer Macro   806.000  i/100ms
          Interactor   923.000  i/100ms
           Decouplio    24.638k i/100ms
Calculating -------------------------------------
                PORO    239.645k (± 4.2%) i/s -      1.186M in   5.046914s
   Trailblazer Macro      7.137k (± 6.1%) i/s -     34.658k in   5.066522s
          Interactor      7.844k (± 5.7%) i/s -     37.843k in   5.042938s
           Decouplio    245.571k (± 4.1%) i/s -      1.207M in   5.052202s
                   with 95.0% confidence

Comparison:
           Decouplio:   245570.5 i/s
                PORO:   239645.3 i/s - same-ish: difference falls within error
          Interactor:     7843.8 i/s - 31.30x  (± 2.24) slower
   Trailblazer Macro:     7137.5 i/s - 34.40x  (± 2.50) slower
                   with 95.0% confidence
```
