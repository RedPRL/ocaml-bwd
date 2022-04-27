# 🔙 Backward Lists

This OCaml package defines backward lists that are isomorphic to lists. They are useful when one wishes to give a different type to the lists that are semantically in reverse. In our experience, it is easy to miss `List.rev` or misuse `List.rev_append` when both semantically forward and backward lists are present. With backward lists having a different type, it is impossible to make those mistakes.

## Stability

The API is relatively stable.

## How to Use It

### OCaml >= 4.14

You need OCaml 4.14.0 or newer to enjoy the [experimental TMC feature](https://www.ocaml.org/manual/tail_mod_cons.html). Otherwise, there will be warnings about incorrect `tailcall` annotations because order versions of OCaml cannot automatically transform some functions into tail-recursive ones.

### OPAM

The package is available in the OPAM repository:
```sh
opam install bwd
```

You can also pin the latest version in development:
```sh
opam pin https://github.com/RedPRL/bwd.git
```

### Example Code

```ocaml
open Bwd
open BwdNotation

(* `Emp` is the empty list and `#<` is snoc (cons in reverse).
   The following expression gives the backward list corresponding to [1; 2; 3]. *)
let b1 : int bwd = Emp #< 1 #< 2 #< 3

(* The library has a few common functions for backward lists.
   The following expression gives the backward list corresponding to [2; 3; 4]. *)
let b2 : int bwd = BwdLabels.map ~f:(fun x -> x + 1) b1

(* bwd yoga 1: `<><` for moving elements from a forward list on the right
   to a backward list on the left. The notation was inspired by Conor McBride.
   The following expression gives the backward list corresponding to [1; 2; 3; 4; 5; 6]. *)
let b3 : int bwd = b1 <>< [4; 5; 6]

(* bwd yoga 2: `<>>` for moving elements from a backward list on the left
   to a forward list on the right. The notation was inspired by Conor McBride.
   The following expression gives the forward list [1; 2; 3; 4; 5; 6; 7; 8; 9]. *)
let l4 : int list = b3 <>> [7; 8; 9]
```

### Documentation

[Here is the API documentation.](https://redprl.org/ocaml-bwd/bwd/)

## Philosophy

### Cherish the Textual Order

The idea is that the textual order of elements should never change---what's on the left should stay on the left. We can then rely on the textual order to keep track of semantic order. We might choose different representations (backward or forward lists) to gain efficient access to the elements on one end, but the textual order remains the same. The function `List.rev` violates this invariant because it gives a new list whose elements are in the opposite textual order. For this reason, the following functions (including `List.rev`) are considered ill-typed and should never be used:

- `List.rev`
- `List.rev_map`
- `List.rev_map2`
- `List.rev_append`

On the other hand, functions in this library (except the general folds) only move elements between forward and backward lists without changing their textual order. The yoga of moving elements should ring a bell for people who have implemented normalization by evaluation (NbE). This simple trick of maintaining textual order seems to have prevented many potential bugs in our proof assistants.

### Minimality

Currently, this library is to serve the development of our proof assistants (for example, [cooltt](https://github.com/RedPRL/cooltt) and [algaett](https://github.com/RedPRL/algaett)), so we include only a tiny collection of functions, and will deprecate unused or ill-designed ones quickly. That said, please [open a GitHub issue](https://github.com/RedPRL/ocaml-bwd/issues/new/choose) if you want some function to be included for your project. We want to make this library useful to you, too!
