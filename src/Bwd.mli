type 'a bwd = 'a BwdDef.bwd =
  | Emp
  | Snoc of 'a bwd * 'a

module Bwd : module type of BwdNoLabels with type 'a t = 'a bwd
module BwdLabels : module type of BwdLabels with type 'a t = 'a bwd
module BwdNotation : module type of BwdNoLabels.Notation
