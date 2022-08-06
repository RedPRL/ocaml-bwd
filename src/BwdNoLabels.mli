(**
   Notes on the discrepancies with {!module:List}:
   {ul
   {- Functions [rev], [rev_append], [rev_map], and [rev_map2] will {i never} be included.}
   {- A new function {!val:prepend} was added as the {i forward} version of {!val:append}.}
   {- A new module {!module:Notation} was added for the infix notation.}
   {- Functions for association lists are currently missing, but might be added later.}
   {- Functions [init], [tl] (as [hd] for lists), [hd] (as [tl] for lists), [merge], [to_seq], and [of_seq] are also missing, but might be added in the future.}}

   Please {{: https://github.com/RedPRL/ocaml-bwd/issues/new/choose}open a GitHub issue} if you want a function to be included.
   We want to make this library useful to you, too!

   @canonical Bwd.Bwd
*)

(** @canonical Bwd.bwd *)
type 'a t = 'a BwdDef.bwd =
  | Emp
  | Snoc of 'a t * 'a

val length : 'a t -> int
val compare_lengths : 'a t -> 'a t -> int
val compare_length_with : 'a t -> int -> int
val snoc : 'a t -> 'a -> 'a t
val nth : 'a t -> int -> 'a
val nth_opt : 'a t -> int -> 'a option
val append : 'a t -> 'a list -> 'a t
val prepend : 'a t -> 'a list -> 'a list

(** {1 Comparison} *)

val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int

(** {1 Iterators}

    Note that the iteration direction is from the right to the left,
    in the opposite direction of the corresponding functions in {!module:List}.
*)

val iter : ('a -> unit) -> 'a t -> unit
val iteri : (int -> 'a -> unit) -> 'a t -> unit
val map : ('a -> 'b) -> 'a t -> 'b t
val mapi : (int -> 'a -> 'b) -> 'a t -> 'b t
val filter_map : ('a -> 'b option) -> 'a t -> 'b t
val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
val fold_right_map : ('a -> 'b -> 'b * 'c) -> 'a t -> 'b -> 'b * 'c t
val fold_right : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b

(** {1 Iterators on two lists}

    Note that the iteration direction is from the right to the left,
    in the opposite direction of the corresponding functions in {!module:List}.
*)

val iter2 : ('a -> 'b -> unit) -> 'a t -> 'b t -> unit
val map2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
val fold_left2 : ('a -> 'b -> 'c -> 'a) -> 'a -> 'b t -> 'c t -> 'a
val fold_right2 : ('a -> 'b -> 'c -> 'c) -> 'a t -> 'b t -> 'c -> 'c

(** {1 List scanning}

    Note that the iteration direction is from the right to the left,
    in the opposite direction of the corresponding functions in {!module:List}.
*)

val for_all : ('a -> bool) -> 'a t -> bool
val exists : ('a -> bool) -> 'a t -> bool
val for_all2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
val exists2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
val mem : 'a -> 'a t -> bool
val memq : 'a -> 'a t -> bool

(** {1 List searching}

    Note that the iteration direction is from the right to the left,
    in the opposite direction of the corresponding functions in {!module:List}.
*)

val find : ('a -> bool) -> 'a t -> 'a
val find_opt : ('a -> bool) -> 'a t -> 'a option
val find_map : ('a -> 'b option) -> 'a t -> 'b option
val filter : ('a -> bool) -> 'a t -> 'a t
val find_all : ('a -> bool) -> 'a t -> 'a t
val filteri : (int -> 'a -> bool) -> 'a t -> 'a t
val partition : ('a -> bool) -> 'a t -> 'a t * 'a t
val partition_map : ('a -> ('b, 'c) Either.t) -> 'a t -> 'b t * 'c t

(** {1 Lists of pairs} *)

val split : ('a * 'b) t -> 'a t * 'b t
val combine : 'a t -> 'b t -> ('a * 'b) t

(** {1 Backward and forward lists} *)

val to_list : 'a t -> 'a list
val of_list : 'a list -> 'a t

(** {1 Infix notation} *)

(** Notation inspired by Conor McBride. *)
module Infix :
sig
  val (#<) : 'a t -> 'a -> 'a t
  (** An alias of {!val:Bwd.snoc}. *)

  val (<><) : 'a t -> 'a list -> 'a t
  (** An alias of {!val:Bwd.append}. *)

  val (<>>) : 'a t -> 'a list -> 'a list
  (** An alias of {!val:Bwd.prepend}. *)
end

(**/**)

module Notation : module type of Infix [@@ocaml.alert deprecated "Use Bwd.Infix instead"]
