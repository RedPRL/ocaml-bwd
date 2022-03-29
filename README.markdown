# 🔙 Backward Lists

This OCaml package defines backward lists that are isomorphic to lists. They are useful when one wishes to give a different type to the lists that are semantically in reverse. In our experience, it is easy to miss `List.rev` or misuse `List.rev_append` when both semantically forward and backward lists are present. With backward lists having a different type, it is impossible to make these mistakes.

## Philosophy

The following functions are considered ill-typed.

- `List.rev`
- `List.rev_map`
- `List.rev_map2`
- `List.rev_append`

One should never reverse a list without changing its type.

## How to Use It

```ocaml
open Bwd
open BwdNotation

let b1 = Emp #< 1 #< 2 #< 3
let b2 = BwdLabels.map ~f:(fun x -> x + 1) b1
```
