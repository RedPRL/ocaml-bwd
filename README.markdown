# 🔙 Backward Lists

This OCaml package defines backward lists that are isomorphic to lists. They are useful when one wishes to give a different type to the lists that are semantically in reverse. In our experience, it is easy to miss `List.rev` or misuse `List.rev_append` when both semantically forward and backward lists are present. With backward lists having a different type, it is impossible to make these mistakes.

## How to Use It

### Example Code

```ocaml
open Bwd
open BwdNotation

let b1 = Emp #< 1 #< 2 #< 3
let b2 = BwdLabels.map ~f:(fun x -> x + 1) b1
```

### Documentation

[Full API documentation](https://redprl.org/ocaml-bwd/bwd/).

## Philosophy

### No List.rev

The following functions are considered ill-typed and should never be used:

- `List.rev`
- `List.rev_map`
- `List.rev_map2`
- `List.rev_append`

One should never reverse a list without changing its type.

### Minimality

This library is currently to serve proof assistants developed by the RedPRL Development Team (for example, cooltt), so we add only include a small collection of functions, and will deprecate unused or ill-designed functions quickly. That said, please [open an GitHub issue](https://github.com/RedPRL/ocaml-bwd/issues/new/choose) if some function will be helpful for your project. We will be happy to see that you find backward lists useful, too!
