open StdLabels
module B = Bwd.BwdLabels
module BN = Bwd.BwdNotation
module L = ListAsBwd
module Q = QCheck2

let of_list =
  let rec go acc =
    function
    | [] -> acc
    | x :: xs -> go (B.Snoc (acc, x)) xs
  in go B.Emp

let to_list =
  let rec go acc =
    function
    | B.Emp -> acc
    | B.Snoc (xs, x) -> go (x :: acc) xs
  in go []

let trap f = try Ok (f ()) with exn -> Error exn

let count = 1000

let test_length =
  Q.Test.make ~count ~name:"length" Q.Gen.(list int) ~print:Q.Print.(list int)
    (fun l -> B.length (of_list l) = L.length l)
let test_snoc =
  Q.Test.make ~count ~name:"snoc" Q.Gen.(pair (list int) int) ~print:Q.Print.(pair (list int) int)
    (fun (xs, x) -> to_list (B.snoc (of_list xs) x) = L.snoc xs x)
let test_nth =
  Q.Test.make ~count ~name:"nth"
    Q.Gen.(pair (list int) small_int)
    ~print:Q.Print.(pair (list int) int)
    (fun (xs, i) ->
       trap (fun () -> B.nth (of_list xs) i)
       =
       trap (fun () -> L.nth xs i))
let test_nth_opt =
  Q.Test.make ~count ~name:"nth_opt"
    Q.Gen.(pair (list int) small_int)
    ~print:Q.Print.(pair (list int) int)
    (fun (xs, i) ->
       trap (fun () -> B.nth_opt (of_list xs) i)
       =
       trap (fun () -> L.nth_opt xs i))
let test_append =
  Q.Test.make ~count ~name:"append" Q.Gen.(pair (list int) (list int))
    ~print:Q.Print.(pair (list int) (list int))
    (fun (xs, ys) -> to_list (B.append (of_list xs) ys) = L.append xs ys)
let test_prepend =
  Q.Test.make ~count ~name:"prepend" Q.Gen.(pair (list int) (list int))
    ~print:Q.Print.(pair (list int) (list int))
    (fun (xs, ys) -> B.prepend (of_list xs) ys = L.prepend xs ys)
let test_equal =
  Q.Test.make ~count ~name:"equal"
    Q.Gen.(triple (Q.fun2 Q.Observable.int Q.Observable.int bool) (list small_int) (list small_int))
    ~print:Q.Print.(triple Q.Fn.print (list int) (list int))
    (fun (Fun (_, eq), xs, ys) -> B.equal ~eq (of_list xs) (of_list ys) = L.equal ~eq xs ys)
let test_compare =
  Q.Test.make ~count ~name:"compare"
    Q.Gen.(triple (Q.fun2 Q.Observable.int Q.Observable.int int) (list small_int) (list small_int))
    ~print:Q.Print.(triple Q.Fn.print (list int) (list int))
    (fun (Fun (_, cmp), xs, ys) -> B.compare ~cmp (of_list xs) (of_list ys) = L.compare ~cmp xs ys)
let test_iter =
  Q.Test.make ~count ~name:"iter" Q.Gen.(list int)
    ~print:Q.Print.(list int)
    (fun l ->
       let calls1 = Stack.create () in
       let calls2 = Stack.create () in
       B.iter ~f:(fun x -> Stack.push x calls1) (of_list l);
       L.iter ~f:(fun x -> Stack.push x calls2) l;
       List.of_seq (Stack.to_seq calls1) = List.of_seq (Stack.to_seq calls2))
let test_map =
  Q.Test.make ~count ~name:"map"
    Q.Gen.(pair (Q.fun1 Q.Observable.int int) (list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> to_list (B.map ~f (of_list xs)) = L.map ~f xs)
let test_mapi =
  Q.Test.make ~count ~name:"mapi"
    Q.Gen.(pair (Q.fun2 Q.Observable.int Q.Observable.int int) (list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> to_list (B.mapi ~f (of_list xs)) = L.mapi ~f xs)
let test_filter_map =
  Q.Test.make ~count ~name:"filter_map"
    Q.Gen.(pair (Q.fun1 Q.Observable.int (opt int)) (list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> to_list (B.filter_map ~f (of_list xs)) = L.filter_map ~f xs)
let test_fold_left =
  Q.Test.make ~count ~name:"fold_left"
    Q.Gen.(triple (Q.fun2 Q.Observable.int Q.Observable.int int) int (list int))
    ~print:Q.Print.(triple Q.Fn.print int (list int))
    (fun (Fun (_, f), init, xs) -> B.fold_left ~f ~init (of_list xs) = L.fold_left ~f ~init xs)
let test_fold_right =
  Q.Test.make ~count ~name:"fold_right"
    Q.Gen.(triple (Q.fun2 Q.Observable.int Q.Observable.int int) (list int) int)
    ~print:Q.Print.(triple Q.Fn.print (list int) int)
    (fun (Fun (_, f), xs, init) -> B.fold_right ~f (of_list xs) ~init = L.fold_right ~f xs ~init)
let test_iter2 =
  Q.Test.make ~count ~name:"iter2" Q.Gen.(pair (list int) (list int))
    ~print:Q.Print.(pair (list int) (list int))
    (fun (l1, l2) ->
       let calls1 = Stack.create () in
       let calls2 = Stack.create () in
       (trap (fun () -> B.iter2 ~f:(fun x y -> Stack.push (x, y) calls1) (of_list l1) (of_list l2))
        =
        trap (fun () -> L.iter2 ~f:(fun x y -> Stack.push (x, y) calls2) l1 l2))
       &&
       (List.of_seq (Stack.to_seq calls1) = List.of_seq (Stack.to_seq calls2)))
let test_fold_right2 =
  Q.Test.make ~count ~name:"fold_right2"
    Q.Gen.(quad (Q.fun3 Q.Observable.int Q.Observable.int Q.Observable.int int) (list int) (list int) int)
    ~print:Q.Print.(quad Q.Fn.print (list int) (list int) int)
    (fun (Fun (_, f), xs, ys, init) ->
       trap (fun () -> B.fold_right2 ~f (of_list xs) (of_list ys) ~init)
       =
       trap (fun () -> L.fold_right2 ~f xs ys ~init))
let test_for_all =
  Q.Test.make ~count ~name:"for_all"
    Q.Gen.(pair (Q.fun1 Q.Observable.int bool) (list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> B.for_all ~f (of_list xs) = L.for_all ~f xs)
let test_exists =
  Q.Test.make ~count ~name:"exists"
    Q.Gen.(pair (Q.fun1 Q.Observable.int bool) (list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> B.exists ~f (of_list xs) = L.exists ~f xs)
let test_mem =
  Q.Test.make ~count ~name:"mem"
    Q.Gen.(pair small_int (list small_int))
    ~print:Q.Print.(pair int (list int))
    (fun (a, set) -> B.mem a ~set:(of_list set) = L.mem a ~set)
let test_filter =
  Q.Test.make ~count ~name:"filter"
    Q.Gen.(pair (Q.fun1 Q.Observable.int bool) (list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> to_list (B.filter ~f (of_list xs)) = L.filter ~f xs)
let test_to_list =
  Q.Test.make ~count ~name:"to_list" Q.Gen.(list int) ~print:Q.Print.(list int)
    (fun xs -> B.to_list (of_list xs) = L.to_list xs)
let test_of_list =
  Q.Test.make ~count ~name:"of_list" Q.Gen.(list int) ~print:Q.Print.(list int)
    (fun xs -> to_list (B.of_list xs) = L.of_list xs)

let (#<) =
  Q.Test.make ~count ~name:"#<" Q.Gen.(pair (list int) int) ~print:Q.Print.(pair (list int) int)
    (fun (xs, x) -> to_list (BN.(#<) (of_list xs) x) = L.(#<) xs x)
let (<><) =
  Q.Test.make ~count ~name:"<><" Q.Gen.(pair (list int) (list int))
    ~print:Q.Print.(pair (list int) (list int))
    (fun (xs, ys) -> to_list (BN.(<><) (of_list xs) ys) = L.(<><) xs ys)
let (<>>) =
  Q.Test.make ~count ~name:"<>>" Q.Gen.(pair (list int) (list int))
    ~print:Q.Print.(pair (list int) (list int))
    (fun (xs, ys) -> BN.(<>>) (of_list xs) ys = L.(<>>) xs ys)


let () =
  exit @@
  QCheck_base_runner.run_tests ~colors:true ~verbose:true ~long:true
    [ test_length
    ; test_snoc
    ; test_nth
    ; test_nth_opt
    ; test_append
    ; test_prepend
    ; test_equal
    ; test_compare
    ; test_iter
    ; test_map
    ; test_mapi
    ; test_filter_map
    ; test_fold_left
    ; test_fold_right
    ; test_iter2
    ; test_fold_right2
    ; test_for_all
    ; test_exists
    ; test_mem
    ; test_filter
    ; test_to_list
    ; test_of_list
    ; (#<)
    ; (<><)
    ; (<>>)
    ]
