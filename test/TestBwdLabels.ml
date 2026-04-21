open StdLabels
module B = Bwd.BwdLabels
module L = ListAsBwdLabels
module Q = QCheck2

let of_list xs =
  let rec go acc =
    function
    | [] -> acc
    | x :: xs -> go (B.Snoc (acc, x)) xs
  in go B.Emp xs

let to_list xs =
  let rec go acc =
    function
    | B.Emp -> acc
    | B.Snoc (xs, x) -> go (x :: acc) xs
  in go [] xs

let trap f = try Ok (f ()) with exn -> Error exn

let count = 10000

let test_length =
  Q.Test.make ~count ~name:"length" Q.Gen.(small_list unit) ~print:Q.Print.(list unit)
    (fun l -> B.length (of_list l) = L.length l)
let test_compare_lengths =
  Q.Test.make ~count ~name:"compare_lengths"
    Q.Gen.(pair (small_list unit) (small_list unit))
    ~print:Q.Print.(pair (list unit) (list unit))
    (fun (xs, ys) -> B.compare_lengths (of_list xs) (of_list ys) = L.compare_lengths xs ys)
let test_compare_length_with =
  Q.Test.make ~count ~name:"compare_length_with"
    Q.Gen.(pair (small_list unit) (small_signed_int))
    ~print:Q.Print.(pair (list unit) int)
    (fun (xs, len) -> B.compare_length_with (of_list xs) ~len = L.compare_length_with xs ~len)
let test_is_empty =
  Q.Test.make ~count ~name:"is_empty"
    Q.Gen.(small_list unit)
    ~print:Q.Print.(list unit)
    (fun xs -> B.is_empty (of_list xs) = L.is_empty xs)
let test_snoc =
  Q.Test.make ~count ~name:"snoc" Q.Gen.(pair (small_list int) int) ~print:Q.Print.(pair (list int) int)
    (fun (xs, x) -> to_list (B.snoc (of_list xs) x) = L.snoc xs x)
let test_nth =
  Q.Test.make ~count ~name:"nth"
    Q.Gen.(pair (small_list int) small_signed_int)
    ~print:Q.Print.(pair (list int) int)
    (fun (xs, i) ->
       trap (fun () -> B.nth (of_list xs) i)
       =
       trap (fun () -> L.nth xs i))
let test_nth_opt =
  Q.Test.make ~count ~name:"nth_opt"
    Q.Gen.(pair (small_list int) small_signed_int)
    ~print:Q.Print.(pair (list int) int)
    (fun (xs, i) ->
       trap (fun () -> B.nth_opt (of_list xs) i)
       =
       trap (fun () -> L.nth_opt xs i))
let test_init =
  Q.Test.make ~count ~name:"init"
    Q.Gen.(pair small_signed_int (Q.fun1 Q.Observable.int (opt int)))
    ~print:Q.Print.(pair int Q.Fn.print)
    (fun (len, Fun (_, f)) -> trap (fun () -> to_list (B.init ~len ~f)) = trap (fun () -> L.init ~len ~f))
let test_append =
  Q.Test.make ~count ~name:"append" Q.Gen.(pair (small_list int) (small_list int))
  ~print:Q.Print.(pair (list int) (list int))
  (fun (xs, ys) -> to_list (B.append (of_list xs) (of_list ys)) = L.append xs ys)
let test_append_list =
  Q.Test.make ~count ~name:"append_list" Q.Gen.(pair (small_list int) (small_list int))
    ~print:Q.Print.(pair (list int) (list int))
    (fun (xs, ys) -> to_list (B.append_list (of_list xs) ys) = L.append xs ys)
let test_prepend_list =
  Q.Test.make ~count ~name:"prepend_list" Q.Gen.(pair (small_list int) (small_list int))
    ~print:Q.Print.(pair (list int) (list int))
    (fun (xs, ys) -> B.prepend_list  (of_list xs) ys = L.prepend xs ys)
let test_equal =
  Q.Test.make ~count ~name:"equal"
    Q.Gen.(triple (Q.fun2 Q.Observable.int Q.Observable.int bool) (small_list small_nat) (small_list small_nat))
    ~print:Q.Print.(triple Q.Fn.print (list int) (list int))
    (fun (Fun (_, eq), xs, ys) -> B.equal ~eq (of_list xs) (of_list ys) = L.equal ~eq xs ys)
let test_compare =
  Q.Test.make ~count ~name:"compare"
    Q.Gen.(triple (Q.fun2 Q.Observable.int Q.Observable.int int) (small_list small_nat) (small_list small_nat))
    ~print:Q.Print.(triple Q.Fn.print (list int) (list int))
    (fun (Fun (_, cmp), xs, ys) -> B.compare ~cmp (of_list xs) (of_list ys) = L.compare ~cmp xs ys)
let test_iter =
  Q.Test.make ~count ~name:"iter" Q.Gen.(small_list int)
    ~print:Q.Print.(list int)
    (fun l ->
       let calls1 = Stack.create () in
       let calls2 = Stack.create () in
       B.iter ~f:(fun x -> Stack.push x calls1) (of_list l);
       L.iter ~f:(fun x -> Stack.push x calls2) l;
       List.of_seq (Stack.to_seq calls1) = List.of_seq (Stack.to_seq calls2))
let test_iteri =
  Q.Test.make ~count ~name:"iteri" Q.Gen.(small_list int)
    ~print:Q.Print.(list int)
    (fun l ->
       let calls1 = Stack.create () in
       let calls2 = Stack.create () in
       B.iteri ~f:(fun i x -> Stack.push (i, x) calls1) (of_list l);
       L.iteri ~f:(fun i x -> Stack.push (i, x) calls2) l;
       List.of_seq (Stack.to_seq calls1) = List.of_seq (Stack.to_seq calls2))
let test_map =
  Q.Test.make ~count ~name:"map"
    Q.Gen.(pair (Q.fun1 Q.Observable.int int) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> to_list (B.map ~f (of_list xs)) = L.map ~f xs)
let test_mapi =
  Q.Test.make ~count ~name:"mapi"
    Q.Gen.(pair (Q.fun2 Q.Observable.int Q.Observable.int int) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> to_list (B.mapi ~f (of_list xs)) = L.mapi ~f xs)
let test_filter_map =
  Q.Test.make ~count ~name:"filter_map"
    Q.Gen.(pair (Q.fun1 Q.Observable.int (opt int)) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> to_list (B.filter_map ~f (of_list xs)) = L.filter_map ~f xs)
let test_fold_left =
  Q.Test.make ~count ~name:"fold_left"
    Q.Gen.(triple (Q.fun2 Q.Observable.int Q.Observable.int int) int (small_list int))
    ~print:Q.Print.(triple Q.Fn.print int (list int))
    (fun (Fun (_, f), init, xs) -> B.fold_left ~f ~init (of_list xs) = L.fold_left ~f ~init xs)
let test_fold_right_map =
  Q.Test.make ~count ~name:"fold_right_map"
    Q.Gen.(triple (Q.fun2 Q.Observable.int Q.Observable.int (pair int int)) (small_list int) int)
    ~print:Q.Print.(triple Q.Fn.print (list int) int)
    (fun (Fun (_, f), xs, init) ->
       (let y, zs = (B.fold_right_map ~f (of_list xs) ~init) in y, to_list zs)
       =
       L.fold_right_map ~f xs ~init)
let test_fold_right =
  Q.Test.make ~count ~name:"fold_right"
    Q.Gen.(triple (Q.fun2 Q.Observable.int Q.Observable.int int) (small_list int) int)
    ~print:Q.Print.(triple Q.Fn.print (list int) int)
    (fun (Fun (_, f), xs, init) -> B.fold_right ~f (of_list xs) ~init = L.fold_right ~f xs ~init)
let test_iter2 =
  Q.Test.make ~count ~name:"iter2" Q.Gen.(pair (small_list int) (small_list int))
    ~print:Q.Print.(pair (list int) (list int))
    (fun (l1, l2) ->
       let calls1 = Stack.create () in
       let calls2 = Stack.create () in
       (trap (fun () -> B.iter2 ~f:(fun x y -> Stack.push (x, y) calls1) (of_list l1) (of_list l2))
        =
        trap (fun () -> L.iter2 ~f:(fun x y -> Stack.push (x, y) calls2) l1 l2))
       &&
       (List.of_seq (Stack.to_seq calls1) = List.of_seq (Stack.to_seq calls2)))
let test_map2 =
  Q.Test.make ~count ~name:"map2"
    Q.Gen.(triple (Q.fun2 Q.Observable.int Q.Observable.int int) (small_list int) (small_list int))
    ~print:Q.Print.(triple Q.Fn.print (list int) (list int))
    (fun (Fun (_, f), xs, ys) ->
       trap (fun () -> to_list (B.map2 ~f (of_list xs) (of_list ys)))
       =
       trap (fun () -> L.map2 ~f xs ys))
let test_fold_left2 =
  Q.Test.make ~count ~name:"fold_left2"
    Q.Gen.(quad (Q.fun3 Q.Observable.int Q.Observable.int Q.Observable.int int) int (small_list int) (small_list int))
    ~print:Q.Print.(quad Q.Fn.print int (list int) (list int))
    (fun (Fun (_, f), init, xs, ys) ->
       trap (fun () -> B.fold_left2 ~f ~init (of_list xs) (of_list ys))
       =
       trap (fun () -> L.fold_left2 ~f ~init xs ys))
let test_fold_right2 =
  Q.Test.make ~count ~name:"fold_right2"
    Q.Gen.(quad (Q.fun3 Q.Observable.int Q.Observable.int Q.Observable.int int) (small_list int) (small_list int) int)
    ~print:Q.Print.(quad Q.Fn.print (list int) (list int) int)
    (fun (Fun (_, f), xs, ys, init) ->
       trap (fun () -> B.fold_right2 ~f (of_list xs) (of_list ys) ~init)
       =
       trap (fun () -> L.fold_right2 ~f xs ys ~init))
let test_for_all =
  Q.Test.make ~count ~name:"for_all"
    Q.Gen.(pair (Q.fun1 Q.Observable.int bool) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> B.for_all ~f (of_list xs) = L.for_all ~f xs)
let test_exists =
  Q.Test.make ~count ~name:"exists"
    Q.Gen.(pair (Q.fun1 Q.Observable.int bool) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> B.exists ~f (of_list xs) = L.exists ~f xs)
let test_for_all2 =
  Q.Test.make ~count ~name:"for_all2"
    Q.Gen.(triple (Q.fun2 Q.Observable.int Q.Observable.int bool) (small_list int) (small_list int))
    ~print:Q.Print.(triple Q.Fn.print (list int) (list int))
    (fun (Fun (_, f), xs, ys) ->
       trap (fun () -> B.for_all2 ~f (of_list xs) (of_list ys))
       =
       trap (fun () -> L.for_all2 ~f xs ys))
let test_exists2 =
  Q.Test.make ~count ~name:"exists2"
    Q.Gen.(triple (Q.fun2 Q.Observable.int Q.Observable.int bool) (small_list int) (small_list int))
    ~print:Q.Print.(triple Q.Fn.print (list int) (list int))
    (fun (Fun (_, f), xs, ys) ->
       trap (fun () -> B.exists2 ~f (of_list xs) (of_list ys))
       =
       trap (fun () -> L.exists2 ~f xs ys))
let test_mem =
  Q.Test.make ~count ~name:"mem"
    Q.Gen.(pair small_nat (small_list small_nat))
    ~print:Q.Print.(pair int (list int))
    (fun (a, set) -> B.mem a ~set:(of_list set) = L.mem a ~set)
let test_memq =
  Q.Test.make ~count ~name:"memq"
    Q.Gen.(pair (opt small_nat) (small_list (opt small_nat))) (* use [int option] to test physical equality *)
    ~print:Q.Print.(pair (option int) (list (option int)))
    (fun (a, set) -> B.memq a ~set:(of_list set) = L.memq a ~set)
let test_find =
  Q.Test.make ~count ~name:"find"
    Q.Gen.(pair (Q.fun1 Q.Observable.int bool) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> trap (fun () -> B.find ~f (of_list xs)) = trap (fun () -> L.find ~f xs))
let test_find_opt =
  Q.Test.make ~count ~name:"find_opt"
    Q.Gen.(pair (Q.fun1 Q.Observable.int bool) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> B.find_opt ~f (of_list xs) = L.find_opt ~f xs)
let test_find_index =
  Q.Test.make ~count ~name:"find_index"
    Q.Gen.(pair (Q.fun1 Q.Observable.int bool) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> B.find_index ~f (of_list xs) = L.find_index ~f xs)
let test_find_map =
  Q.Test.make ~count ~name:"find_map"
    Q.Gen.(pair (Q.fun1 Q.Observable.int (opt int)) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> B.find_map ~f (of_list xs) = L.find_map ~f xs)
let test_find_mapi =
  Q.Test.make ~count ~name:"find_mapi"
    Q.Gen.(pair (Q.fun2 Q.Observable.int Q.Observable.int (opt int)) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> B.find_mapi ~f (of_list xs) = L.find_mapi ~f xs)
let test_filter =
  Q.Test.make ~count ~name:"filter"
    Q.Gen.(pair (Q.fun1 Q.Observable.int bool) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> to_list (B.filter ~f (of_list xs)) = L.filter ~f xs)
let test_find_all =
  Q.Test.make ~count ~name:"find_all"
    Q.Gen.(pair (Q.fun1 Q.Observable.int bool) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> to_list (B.find_all ~f (of_list xs)) = L.find_all ~f xs)
let test_filteri =
  Q.Test.make ~count ~name:"filteri"
    Q.Gen.(pair (Q.fun2 Q.Observable.int Q.Observable.int bool) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) -> to_list (B.filteri ~f (of_list xs)) = L.filteri ~f xs)
let test_partition =
  Q.Test.make ~count ~name:"partition"
    Q.Gen.(pair (Q.fun1 Q.Observable.int bool) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) ->
       (let xs, ys = B.partition ~f (of_list xs) in to_list xs, to_list ys)
       =
       L.partition ~f xs)
let test_partition_map =
  Q.Test.make ~count ~name:"partition_map"
    Q.Gen.(pair (Q.fun1 Q.Observable.int (pair bool int)) (small_list int))
    ~print:Q.Print.(pair Q.Fn.print (list int))
    (fun (Fun (_, f), xs) ->
       let f x = match f x with true, y -> Either.Left y | false, y -> Either.Right y in
       (let xs, ys = B.partition_map ~f (of_list xs) in to_list xs, to_list ys)
       =
       L.partition_map ~f xs)
let test_split =
  Q.Test.make ~count ~name:"split"
    Q.Gen.(small_list (pair int int))
    ~print:Q.Print.(list (pair int int))
    (fun xs ->
       (let xs, ys = B.split (of_list xs) in to_list xs, to_list ys)
       =
       L.split xs)
let test_combine =
  Q.Test.make ~count ~name:"combine"
    Q.Gen.(pair (small_list int) (small_list int))
    ~print:Q.Print.(pair (list int) (list int))
    (fun (xs, ys) ->
       trap (fun () -> to_list (B.combine (of_list xs) (of_list ys)))
       =
       trap (fun () -> L.combine xs ys))
let test_to_list =
  Q.Test.make ~count ~name:"to_list" Q.Gen.(small_list int) ~print:Q.Print.(list int)
    (fun xs -> B.to_list (of_list xs) = L.to_list xs)
let test_of_list =
  Q.Test.make ~count ~name:"of_list" Q.Gen.(small_list int) ~print:Q.Print.(list int)
    (fun xs -> to_list (B.of_list xs) = L.of_list xs)

let (<:) =
  Q.Test.make ~count ~name:"(<:)" Q.Gen.(pair (small_list int) int) ~print:Q.Print.(pair (list int) int)
    (fun (xs, x) -> to_list (B.Infix.(<:) (of_list xs) x) = L.(<:) xs x)
let (<@) =
  Q.Test.make ~count ~name:"(<@)" Q.Gen.(pair (small_list int) (small_list int))
    ~print:Q.Print.(pair (list int) (list int))
    (fun (xs, ys) -> to_list (B.Infix.(<@) (of_list xs) ys) = L.(<@) xs ys)
let (@>) =
  Q.Test.make ~count ~name:"(@>)" Q.Gen.(pair (small_list int) (small_list int))
    ~print:Q.Print.(pair (list int) (list int))
    (fun (xs, ys) -> B.Infix.(@>) (of_list xs) ys = L.(@>) xs ys)
let (#<) =
  Q.Test.make ~count ~name:"(#<)" Q.Gen.(pair (small_list int) int) ~print:Q.Print.(pair (list int) int)
    (fun (xs, x) -> to_list (B.Infix.(#<) (of_list xs) x) = L.(#<) xs x)
  [@alert "-deprecated"]
let (<><) =
  Q.Test.make ~count ~name:"(<><)" Q.Gen.(pair (small_list int) (small_list int))
    ~print:Q.Print.(pair (list int) (list int))
    (fun (xs, ys) -> to_list (B.Infix.(<><) (of_list xs) ys) = L.(<><) xs ys)
  [@alert "-deprecated"]
let (<>>) =
  Q.Test.make ~count ~name:"(<>>)" Q.Gen.(pair (small_list int) (small_list int))
    ~print:Q.Print.(pair (list int) (list int))
    (fun (xs, ys) -> B.Infix.(<>>) (of_list xs) ys = L.(<>>) xs ys)
  [@alert "-deprecated"]

let () =
  exit @@
  QCheck_base_runner.run_tests ~colors:true ~verbose:true ~long:true
    [
      test_length;
      test_compare_lengths;
      test_compare_length_with;
      test_is_empty;
      test_snoc;
      test_nth;
      test_nth_opt;
      test_init;
      test_append;
      test_append_list;
      test_prepend_list;
      test_equal;
      test_compare;
      test_iter;
      test_iteri;
      test_map;
      test_mapi;
      test_filter_map;
      test_fold_left;
      test_fold_right_map;
      test_fold_right;
      test_iter2;
      test_map2;
      test_fold_left2;
      test_fold_right2;
      test_for_all;
      test_exists;
      test_for_all2;
      test_exists2;
      test_mem;
      test_memq;
      test_find;
      test_find_opt;
      test_find_index;
      test_find_map;
      test_find_mapi;
      test_filter;
      test_find_all;
      test_filteri;
      test_partition;
      test_partition_map;
      test_split;
      test_combine;
      test_to_list;
      test_of_list;
      (<:);
      (<@);
      (@>);
      (#<);
      (<><);
      (<>>);
    ]
