type 'a t = 'a BwdDef.bwd =
  | Emp
  | Snoc of 'a t * 'a

let length xs = BwdNoLabels.length xs

let compare_lengths xs ys = BwdNoLabels.compare_lengths xs ys

let compare_length_with xs ~len = BwdNoLabels.compare_length_with xs len

let snoc l x = BwdNoLabels.snoc l x

let nth xs i = BwdNoLabels.nth xs i

let nth_opt xs i = BwdNoLabels.nth_opt xs i

let append xs ys = BwdNoLabels.append xs ys

let prepend xs ys = BwdNoLabels.prepend xs ys

let equal ~eq xs ys = BwdNoLabels.equal eq xs ys

let compare ~cmp xs ys = BwdNoLabels.compare cmp xs ys

let iter ~f = BwdNoLabels.iter f

let iteri ~f = BwdNoLabels.iteri f

let map ~f = BwdNoLabels.map f

let mapi ~f = BwdNoLabels.mapi f

let filter_map ~f = BwdNoLabels.filter_map f

let fold_left ~f ~init = BwdNoLabels.fold_left f init

let fold_right_map ~f xs ~init = BwdNoLabels.fold_right_map f xs init

let fold_right ~f xs ~init = BwdNoLabels.fold_right f xs init

let iter2 ~f xs ys = BwdNoLabels.iter2 f xs ys

let map2 ~f xs ys = BwdNoLabels.map2 f xs ys

let fold_left2 ~f ~init = BwdNoLabels.fold_left2 f init

let fold_right2 ~f xs ys ~init = BwdNoLabels.fold_right2 f xs ys init

let for_all ~f = BwdNoLabels.for_all f

let for_all2 ~f = BwdNoLabels.for_all2 f

let exists ~f = BwdNoLabels.exists f

let exists2 ~f = BwdNoLabels.exists2 f

let mem a ~set = BwdNoLabels.mem a set

let memq a ~set = BwdNoLabels.memq a set

let find ~f = BwdNoLabels.find f

let find_opt ~f = BwdNoLabels.find_opt f

let find_map ~f = BwdNoLabels.find_map f

let filter ~f = BwdNoLabels.filter f

let find_all ~f = BwdNoLabels.find_all f

let filteri ~f = BwdNoLabels.filteri f

let partition ~f = BwdNoLabels.partition f

let partition_map ~f = BwdNoLabels.partition_map f

let split xs = BwdNoLabels.split xs

let combine xs ys = BwdNoLabels.combine xs ys

let to_list xs = BwdNoLabels.to_list xs

let of_list xs = BwdNoLabels.of_list xs

module Notation = BwdNoLabels.Notation
