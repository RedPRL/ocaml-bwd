module L = ListLabels

let length xs = L.length xs

let compare_lengths = L.compare_lengths

let compare_length_with = L.compare_length_with

let snoc l x = l @ [x]

let nth xs i =
  try L.nth (L.rev xs) i with
  | Failure _ -> failwith "Bwd.nth"
  | Invalid_argument _ -> invalid_arg "Bwd.nth"

let nth_opt xs i =
  try L.nth_opt (L.rev xs) i with
  | Invalid_argument _ -> invalid_arg "Bwd.nth"

let append xs ys = xs @ ys

let prepend xs ys = xs @ ys

let concat = List.concat

let flatten = List.flatten

let equal ~eq xs ys = L.equal ~eq (L.rev xs) (L.rev ys)

let compare ~cmp xs ys = L.compare ~cmp (L.rev xs) (L.rev ys)

let iter ~f xs = L.iter ~f (L.rev xs)

let iteri ~f xs = L.iteri ~f (L.rev xs)

let map ~f xs = L.rev @@ L.map ~f (L.rev xs)

let mapi ~f xs = L.rev @@ L.mapi ~f (L.rev xs)

let filter_map ~f xs = L.rev (L.filter_map ~f (L.rev xs))

let fold_left ~f ~init xs = L.fold_right ~f:(Fun.flip f) (L.rev xs) ~init

let fold_right_map ~f xs ~init =
  let y, zs = L.fold_left_map ~f:(Fun.flip f) ~init (L.rev xs) in
  y, L.rev zs

let fold_right ~f xs ~init = L.fold_left ~f:(Fun.flip f) ~init (L.rev xs)

let iter2 ~f xs ys =
  try L.iter2 ~f (List.rev xs) (List.rev ys) with
  | Invalid_argument _ -> invalid_arg "Bwd.iter2"

let map2 ~f xs ys =
  try L.rev (L.map2 ~f (List.rev xs) (List.rev ys)) with
  | Invalid_argument _ -> invalid_arg "Bwd.map2"

let fold_left2 ~f ~init xs ys =
  try L.fold_left2 ~f xs ys ~init with
  | Invalid_argument _ -> invalid_arg "Bwd.fold_left2"

let fold_right2 ~f xs ys ~init =
  try L.fold_right2 ~f xs ys ~init with
  | Invalid_argument _ -> invalid_arg "Bwd.fold_right2"

let for_all ~f xs = L.for_all ~f (L.rev xs)

let exists ~f xs = L.exists ~f (L.rev xs)

let for_all2 ~f xs ys =
  try L.for_all2 ~f (L.rev xs) (L.rev ys) with
  | Invalid_argument _ -> invalid_arg "Bwd.for_all2"

let exists2 ~f xs ys =
  try L.exists2 ~f (L.rev xs) (L.rev ys) with
  | Invalid_argument _ -> invalid_arg "Bwd.exists2"

let mem a ~set = L.mem a ~set:(L.rev set)

let memq a ~set = L.memq a ~set:(L.rev set)

let find ~f xs = L.find ~f (L.rev xs)

let find_opt ~f xs = L.find_opt ~f (L.rev xs)

let find_map ~f xs = L.find_map ~f (L.rev xs)

let filter ~f xs = L.rev (L.filter ~f (L.rev xs))

let find_all ~f xs = L.rev (L.find_all ~f (L.rev xs))

let filteri ~f xs = L.rev (L.filteri ~f (L.rev xs))

let partition ~f xs =
  let ys, zs = L.partition ~f (L.rev xs) in
  L.rev ys, L.rev zs

let partition_map ~f xs =
  let ys, zs = L.partition_map ~f (L.rev xs) in
  L.rev ys, L.rev zs

let split xs = L.split xs

let combine xs ys =
  try L.combine xs ys with
  | Invalid_argument _ -> invalid_arg "Bwd.combine"

let to_list xs = xs

let of_list xs = xs

let (#<) xs x = snoc xs x
let (<>>) xs ys = prepend xs ys
let (<><) xs ys = append xs ys

let (<:) xs x = snoc xs x
let (<@) xs ys = append xs ys
let (@>) xs ys = prepend xs ys
