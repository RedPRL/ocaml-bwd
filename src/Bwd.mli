type 'a bwd =
  | Emp
  | Snoc of 'a bwd * 'a

module BwdLabels :
sig
  (** This module mimics a small part of the {!module:Stdlib.ListLabels} module. *)

  type 'a t = 'a bwd =
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

  (** {1 Iterators} *)

  val iter : f:('a -> unit) -> 'a t -> unit
  val map : f:('a -> 'b) -> 'a t -> 'b t
  val mapi : f:(int -> 'a -> 'b) -> 'a t -> 'b t
  val filter_map : f:('a -> 'b option) -> 'a t -> 'b t

  val concat_map : f:('a -> 'b list) -> 'a t -> 'b t
  [@@ocaml.alert deprecated "This function is ill-designed and will be removed or changed in the next major release."]

  val fold_left : f:('a -> 'b -> 'a) -> init:'a -> 'b t -> 'a
  val fold_right : f:('a -> 'b -> 'b) -> 'a t -> init:'b -> 'b

  (** {1 Iterators on two lists} *)

  val iter2 : f:('a -> 'b -> unit) -> 'a t -> 'b t -> unit
  val fold_right2 : f:('a -> 'b -> 'c -> 'c) -> 'a t -> 'b t -> init:'c -> 'c

  (** {1 List scanning} *)

  val for_all : f:('a -> bool) -> 'a t -> bool
  val exists : f:('a -> bool) -> 'a t -> bool
  val mem : 'a -> set:'a t -> bool

  (** {1 List searching} *)

  val filter : f:('a -> bool) -> 'a t -> 'a t

  (** {1 Backward and forward lists} *)

  val to_list : 'a t -> 'a list
  val of_list : 'a list -> 'a t
end

module BwdNotation :
sig
  (** Notation inspired by Conor McBride. *)
  val (#<) : 'a bwd -> 'a -> 'a bwd
  val (<><) : 'a bwd -> 'a list -> 'a bwd
  val (<>>) : 'a bwd -> 'a list -> 'a list
end
