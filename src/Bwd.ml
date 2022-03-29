type 'a bwd =
  | Emp
  | Snoc of 'a bwd * 'a

module BwdLabels =
struct
  type 'a t = 'a bwd =
    | Emp
    | Snoc of 'a t * 'a

  let length xs =
    let rec go acc =
      function
      | Emp -> acc
      | Snoc (xs, _) -> (go[@tailcall]) (acc+1) xs
    in
    go 0 xs

  let snoc l x = Snoc (l, x)

  let nth xs i =
    if i < 0 then
      invalid_arg "Bwd.nth"
    else
      let rec go =
        function
        | Emp, _ -> failwith "Bwd.nth"
        | Snoc (_, x), 0 -> x
        | Snoc (xs, _), i -> (go[@tailcall]) (xs, i - 1)
      in go (xs, i)

  let append xs ys =
    let rec go =
      function
      | xs, [] -> xs
      | xs, y :: ys ->
        go (Snoc (xs, y), ys)
    in go (xs, ys)

  let prepend xs ys =
    let rec go =
      function
      | Emp, ys -> ys
      | Snoc (xs, x), ys ->
        go (xs, x :: ys)
    in go (xs, ys)

  module Notation =
  struct
    let (#<) = snoc
    let (<><) = append
    let (<>>) = prepend
  end

  let equal ~eq xs ys =
    let rec go =
      function
      | Emp, Emp -> true
      | Snoc (xs, x), Snoc (ys, y) ->
        eq x y && go (xs, ys)
      | _ -> false
    in go (xs, ys)

  let compare ~cmp xs ys =
    let rec go =
      function
      | Emp, Emp -> 0
      | Emp, _ -> -1
      | _, Emp -> 1
      | Snoc (xs, x), Snoc (ys, y) ->
        let c = cmp x y in
        if c <> 0 then c else go (xs, ys)
    in go (xs, ys)

  let iter ~f =
    let rec go =
      function
      | Emp -> ()
      | Snoc (xs, x) ->
        f x; (go[@tailcall]) xs
    in go

  let map ~f =
    let rec go =
      function
      | Emp -> Emp
      | Snoc (xs, x) -> Snoc (go xs, f x)
    in go

  let mapi ~f =
    let rec go i =
      function
      | Emp -> Emp
      | Snoc (xs, x) -> Snoc (go (i + 1) xs, f i x)
    in
    go 0

  let filter_map ~f =
    let rec go =
      function
      | Emp -> Emp
      | Snoc (xs, x) ->
        match f x with
        | None -> go xs
        | Some fx -> Snoc (go xs, fx)
    in go

  let concat_map ~f =
    let rec go =
      function
      | Emp -> Emp
      | Snoc (xs, x) -> append (go xs) (f x)
    in go

  let fold_left ~f ~init =
    let rec go =
      function
      | Emp -> init
      | Snoc (xs, x) ->
        f (go xs) x
    in go

  let fold_right ~f xs ~init =
    let rec go init =
      function
      | Emp -> init
      | Snoc (xs, x) ->
        let init = f x init in
        go init xs
    in go init xs

  let fold_right2 ~f xs ys ~init =
    let rec go init =
      function
      | Emp, Emp -> init
      | Snoc (xs, x), Snoc (ys, y) ->
        let init = f x y init in
        go init (xs, ys)
      | _ -> invalid_arg "Bwd.fold_right2"
    in
    go init (xs, ys)

  let for_all ~f =
    let rec go =
      function
      | Emp -> true
      | Snoc (xs, x) ->
        f x && (go[@tailcall]) xs
    in go

  let exists ~f =
    let rec go =
      function
      | Emp -> false
      | Snoc (xs, x) ->
        f x || (go[@tailcall]) xs
    in go

  let mem a ~set =
    let rec go =
      function
      | Emp -> false
      | Snoc (xs, x) ->
        a = x || (go[@tailcall]) xs
    in go set

  let filter ~f =
    let rec go =
      function
      | Emp -> Emp
      | Snoc (xs, x) ->
        if f x then
          go xs
        else
          Snoc (go xs, x)
    in go

  let to_list xs =
    prepend xs []

  let of_list xs =
    append Emp xs
end
