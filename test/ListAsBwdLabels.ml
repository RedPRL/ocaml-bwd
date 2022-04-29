module L = ListLabels

let length xs = L.length xs

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

let equal ~eq xs ys =
  let rec go =
    function
    | [], [] -> true
    | x::xs, y::ys -> eq x y && go (xs, ys)
    | _ -> false
  in
  go (List.rev xs, List.rev ys)

let compare ~cmp xs ys =
  let rec go =
    function
    | [], [] -> 0
    | _::_, [] -> 1
    | [], _::_ -> -1
    | x::xs, y::ys ->
      let c = cmp x y in
      if c <> 0 then c else go (xs, ys)
  in
  go (List.rev xs, List.rev ys)

let iter ~f xs = L.iter ~f (L.rev xs)

let map ~f xs = L.rev @@ L.map ~f (L.rev xs)

let mapi ~f xs = L.rev @@ L.mapi ~f (L.rev xs)

let filter_map ~f xs = L.rev (L.filter_map ~f (L.rev xs))

let fold_left ~f ~init = L.fold_left ~f ~init

let fold_right ~f xs ~init = L.fold_right ~f xs ~init

let iter2 ~f xs ys =
  try L.iter2 ~f (List.rev xs) (List.rev ys) with
  | Invalid_argument _ -> invalid_arg "Bwd.iter2"

let fold_right2 ~f xs ys ~init =
  try L.fold_right2 ~f xs ys ~init with
  | Invalid_argument _ -> invalid_arg "Bwd.fold_right2"

let for_all ~f xs = L.for_all ~f (L.rev xs)

let exists ~f xs = L.exists ~f (L.rev xs)

let mem a ~set = L.mem a ~set:(L.rev set)

let filter ~f xs = L.rev (L.filter ~f (L.rev xs))

let to_list xs = xs

let of_list xs = xs

let (#<) xs x = snoc xs x
let (<>>) xs ys = prepend xs ys
let (<><) xs ys = append xs ys
