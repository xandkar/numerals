module List = ListLabels

module Number : sig
  type t

  val nil       : t
  val add_n     : t -> int -> t
  val to_string : t -> string
end = struct
  module Unit = struct
    module X5 = struct
      type x5 =
        | V
        | L
        | D

      let to_string = function
        | V -> "V"
        | L -> "L"
        | D -> "D"
    end

    type t =
      | I
      | X
      | C
      | M

    let fail n =
      failwith ("Don't know the symbol for " ^ n ^ ". TODO: Look it up!")

    let to_string = function
      | I -> "I"
      | X -> "X"
      | C -> "C"
      | M -> "M"

    let x5 = function
      | I -> X5.V
      | X -> X5.L
      | C -> X5.D
      | M -> fail "5_000"

    let x10 = function
      | I -> X
      | X -> C
      | C -> M
      | M -> fail "10_000"
  end

  type base_cycle_state =
    | X_0
    | X_1
    | X_2
    | X_3
    | X_5__sub_1
    | X_5
    | X_5__add_1
    | X_5__add_2
    | X_5__add_3
    | X_10__sub_1

  type t =
    base_cycle_state list

  let nil =
    []

  let to_string = function
    | [] ->
        "nulla"
    | t ->
        let _, strings =
          List.fold_left t ~init:((fun () -> Unit.I), []) ~f:
          (fun (u, strings) base_cycle_state ->
            let u = u () in
            let strings =
              let x1     = Unit.to_string u in
              let x5  () = Unit.X5.to_string (Unit.x5 u) in
              let x10 () = Unit.to_string (Unit.x10 u) in
              let string =
                String.concat ""
                ( match base_cycle_state with
                | X_0         -> [""]
                | X_1         -> [x1]
                | X_2         -> [x1; x1]
                | X_3         -> [x1; x1; x1]
                | X_5__sub_1  -> [x1; x5 ()]
                | X_5         -> [x5 ()]
                | X_5__add_1  -> [x5 (); x1]
                | X_5__add_2  -> [x5 (); x1; x1]
                | X_5__add_3  -> [x5 (); x1; x1; x1]
                | X_10__sub_1 -> [x1; x10 ()]
                )
              in
              string :: strings
            in
            ((fun () -> Unit.x10 u), strings)
          )
        in
        String.concat "" strings

  let rec add_1 = function
    | []                    -> X_1         :: []
    | X_0         :: cycles -> X_1         :: cycles
    | X_1         :: cycles -> X_2         :: cycles
    | X_2         :: cycles -> X_3         :: cycles
    | X_3         :: cycles -> X_5__sub_1  :: cycles
    | X_5__sub_1  :: cycles -> X_5         :: cycles
    | X_5         :: cycles -> X_5__add_1  :: cycles
    | X_5__add_1  :: cycles -> X_5__add_2  :: cycles
    | X_5__add_2  :: cycles -> X_5__add_3  :: cycles
    | X_5__add_3  :: cycles -> X_10__sub_1 :: cycles
    | X_10__sub_1 :: cycles -> X_0         :: add_1 cycles

  let add_n t n =
    let rec list_init x n = if n < 1 then [] else x :: list_init x (n - 1) in
    List.fold_left (list_init () n) ~init:t ~f:(fun t () -> add_1 t)
end

let () =
  let n = int_of_string Sys.argv.(1) in
  print_endline (Number.to_string (Number.add_n Number.nil n))
