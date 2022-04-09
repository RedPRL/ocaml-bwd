module L = ListLabels

let length xs = L.length xs

let snoc l x = l @ [x]

let nth xs i =
  try L.nth (L.rev xs) i with
  | Failure _ -> failwith "BwdLabels.nth"
  | Invalid_argument _ -> invalid_arg "BwdLabels.nth"

let nth_opt xs i =
  try L.nth_opt (L.rev xs) i with
  | Invalid_argument _ -> invalid_arg "BwdLabels.nth"

let append xs ys = xs @ ys

let prepend xs ys = xs @ ys

let equal ~eq xs ys = L.equal ~eq (L.rev xs) (L.rev ys)

let compare ~cmp xs ys = L.compare ~cmp (L.rev xs) (L.rev ys)

let iter ~f xs = L.iter ~f (L.rev xs)

let map ~f xs = L.rev @@ L.map ~f (L.rev xs)

let mapi ~f xs = L.rev @@ L.mapi ~f (L.rev xs)

let filter_map ~f xs = L.rev (L.filter_map ~f (L.rev xs))

let fold_left ~f ~init = L.fold_left ~f ~init

let fold_right ~f xs ~init = L.fold_right ~f xs ~init

let fold_right2 ~f xs ys ~init =
  try L.fold_right2 ~f xs ys ~init with
  | Invalid_argument _ -> invalid_arg "BwdLabels.fold_right2"

let for_all ~f xs = L.for_all ~f (L.rev xs)

let exists ~f xs = L.exists ~f (L.rev xs)

let mem a ~set = L.mem a ~set:(L.rev set)

let filter ~f xs = L.rev (L.filter ~f (L.rev xs))

let to_list xs = xs

let of_list xs = xs

let (#<) xs x = snoc xs x
let (<>>) xs ys = prepend xs ys
let (<><) xs ys = append xs ys
