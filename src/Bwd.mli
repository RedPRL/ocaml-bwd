type 'a bwd = 'a BwdDef.bwd =
  | Emp
  | Snoc of 'a bwd * 'a

(** This module is similar to {!module:List} but for backward lists. *)
module Bwd : module type of BwdNoLabels

(** This module is similar to {!module:ListLabels} but for backward lists. *)
module BwdLabels : module type of BwdLabels

(** An alias of {!module:Bwd.Notation} for infix notation. *)
module BwdNotation : module type of BwdNotation
