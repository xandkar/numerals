module List = ListLabels

module Number : sig
  type t

  val zero : t
  val add  : t -> int -> t
  val to_string : t -> string
end = struct
  module Digit = struct
    type t =
      | D0
      | D1
      | D2
      | D3
      | D4
      | D5
      | D6
      | D7
      | D8
      | D9

    let to_string = function
      | D0 -> "0"
      | D1 -> "1"
      | D2 -> "2"
      | D3 -> "3"
      | D4 -> "4"
      | D5 -> "5"
      | D6 -> "6"
      | D7 -> "7"
      | D8 -> "8"
      | D9 -> "9"
  end

  type t =
    Digit.t list

  let to_string = function
    | [] ->
        Digit.to_string Digit.D0
    | t ->
        String.concat "" (List.rev (List.map t ~f:Digit.to_string))

  let zero =
    [Digit.D0]

  let rec add_1 : (t -> t) = function
    | []             -> Digit.D1 :: []
    | Digit.D0 :: ds -> Digit.D1 :: ds
    | Digit.D1 :: ds -> Digit.D2 :: ds
    | Digit.D2 :: ds -> Digit.D3 :: ds
    | Digit.D3 :: ds -> Digit.D4 :: ds
    | Digit.D4 :: ds -> Digit.D5 :: ds
    | Digit.D5 :: ds -> Digit.D6 :: ds
    | Digit.D6 :: ds -> Digit.D7 :: ds
    | Digit.D7 :: ds -> Digit.D8 :: ds
    | Digit.D8 :: ds -> Digit.D9 :: ds
    | Digit.D9 :: ds -> Digit.D0 :: add_1 ds

  let add t n =
    let rec list_init x n = if n < 1 then [] else x :: list_init x (n - 1) in
    List.fold_left (list_init () n) ~init:t ~f:(fun t () -> add_1 t)
end

let () =
  let n = int_of_string Sys.argv.(1) in
  print_endline (Number.to_string (Number.add Number.zero n))
