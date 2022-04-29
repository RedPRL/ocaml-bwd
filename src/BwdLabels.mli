(** This module mimics a small part of the {!module:Stdlib.ListLabels} module.

    Currently, this library is to serve the development of our proof assistants (for example, {{: https://github.com/RedPRL/cooltt}cooltt} and {{: https://github.com/RedPRL/algaett}algaett}), so we include only a tiny collection of functions, and will deprecate unused or ill-designed ones quickly. That said, please {{: https://github.com/RedPRL/ocaml-bwd/issues/new/choose}open a GitHub issue} if you want some function to be included for your project. We want to make this library useful to you, too! *)

type 'a t = 'a BwdDef.bwd =
  | Emp
  | Snoc of 'a t * 'a

val length : 'a t -> int
val snoc : 'a t -> 'a -> 'a t
val nth : 'a t -> int -> 'a
val nth_opt : 'a t -> int -> 'a option
val append : 'a t -> 'a list -> 'a t
val prepend : 'a t -> 'a list -> 'a list

(** {1 Comparison} *)

val equal : eq:('a -> 'a -> bool) -> 'a t -> 'a t -> bool
val compare : cmp:('a -> 'a -> int) -> 'a t -> 'a t -> int

(** {1 Iterators}

    Note that the iteration direction is from the right to the left,
    in the opposite direction of the corresponding functions in {!module:Stdlib.ListLabels}.
*)

val iter : f:('a -> unit) -> 'a t -> unit
val map : f:('a -> 'b) -> 'a t -> 'b t
val mapi : f:(int -> 'a -> 'b) -> 'a t -> 'b t
val filter_map : f:('a -> 'b option) -> 'a t -> 'b t

val fold_left : f:('a -> 'b -> 'a) -> init:'a -> 'b t -> 'a
val fold_right : f:('a -> 'b -> 'b) -> 'a t -> init:'b -> 'b

(** {1 Iterators on two lists}

    Note that the iteration direction is from the right to the left,
    in the opposite direction of the corresponding functions in {!module:Stdlib.ListLabels}.
*)

val iter2 : f:('a -> 'b -> unit) -> 'a t -> 'b t -> unit
val fold_right2 : f:('a -> 'b -> 'c -> 'c) -> 'a t -> 'b t -> init:'c -> 'c

(** {1 List scanning}

    Note that the iteration direction is from the right to the left,
    in the opposite direction of the corresponding functions in {!module:Stdlib.ListLabels}.
*)

val for_all : f:('a -> bool) -> 'a t -> bool
val exists : f:('a -> bool) -> 'a t -> bool
val mem : 'a -> set:'a t -> bool

(** {1 List searching}

    Note that the iteration direction is from the right to the left,
    in the opposite direction of the corresponding functions in {!module:Stdlib.ListLabels}.
*)

val filter : f:('a -> bool) -> 'a t -> 'a t

(** {1 Backward and forward lists} *)

val to_list : 'a t -> 'a list
val of_list : 'a list -> 'a t

module Notation :
sig
  (** Notation inspired by Conor McBride. *)
  val (#<) : 'a t -> 'a -> 'a t
  val (<><) : 'a t -> 'a list -> 'a t
  val (<>>) : 'a t -> 'a list -> 'a list
end
