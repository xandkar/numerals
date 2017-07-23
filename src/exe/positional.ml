module Number : sig
  type 'a t

  val nil : 'a list -> 'a t

  val add_n : 'a t -> int -> 'a t

  val show : 'a t -> 'a list
end = struct
  type 'symbol t =
    { sequence  : 'symbol list
    ; positions : ('symbol list) list
    }

  let nil sequence =
    {sequence; positions = []}

  let show {sequence; positions} =
    match positions with
    | [] -> [List.hd sequence]
    | _  -> List.(rev (map hd positions))

  let add_1 ({sequence = sequence_0; positions} as t) =
    let rec add_1 = function
      |                             [] -> [List.tl sequence_0]
      |               []  :: _         -> assert false
      | (_ ::         []) :: positions -> sequence_0 :: (add_1 positions)
      | (_ :: sequence_1) :: positions -> sequence_1 :: positions
    in
    {t with positions = add_1 positions}

  let rec add_n t n =
    if n < 1 then t else add_n (add_1 t) (n - 1)
end

let () =
  let sequence = String.split_on_char ',' Sys.argv.(1) in
  let n = int_of_string Sys.argv.(2) in
  Printf.printf "%s" (String.concat "" Number.(show (add_n (nil sequence) n)))
