type 'a t = 'a BwdDef.bwd =
  | Emp
  | Snoc of 'a t * 'a

let length xs = BwdNoLabels.length xs

let snoc l x = BwdNoLabels.snoc l x

let nth xs i = BwdNoLabels.nth xs i

let nth_opt xs i = BwdNoLabels.nth_opt xs i

let append xs ys = BwdNoLabels.append xs ys

let prepend xs ys = BwdNoLabels.prepend xs ys

let equal ~eq xs ys = BwdNoLabels.equal eq xs ys

let compare ~cmp xs ys = BwdNoLabels.compare cmp xs ys

let iter ~f = BwdNoLabels.iter f

let map ~f = BwdNoLabels.map f

let mapi ~f = BwdNoLabels.mapi f

let filter_map ~f = BwdNoLabels.filter_map f

let fold_left ~f ~init = BwdNoLabels.fold_left f init

let fold_right ~f xs ~init = BwdNoLabels.fold_right f xs init

let iter2 ~f xs ys = BwdNoLabels.iter2 f xs ys

let fold_right2 ~f xs ys ~init = BwdNoLabels.fold_right2 f xs ys init

let for_all ~f = BwdNoLabels.for_all f

let exists ~f = BwdNoLabels.exists f

let mem a ~set = BwdNoLabels.mem a set

let filter ~f = BwdNoLabels.filter f

let to_list xs = BwdNoLabels.to_list xs

let of_list xs = BwdNoLabels.of_list xs

module Notation = BwdNoLabels.Notation
