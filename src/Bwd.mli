type 'a bwd = 'a BwdDef.bwd =
  | Emp
  | Snoc of 'a bwd * 'a

module Bwd : module type of BwdNoLabels
module BwdLabels : module type of BwdLabels
module BwdNotation : module type of BwdNoLabels.Notation
