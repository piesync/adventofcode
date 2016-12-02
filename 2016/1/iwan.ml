module Utils = struct
  let split ~on str = Str.split (Str.regexp on) str

  exception Empty_List of unit
  let last lst =
    let rec last' lst = match lst with
            | x :: [] -> x
            | x :: xs -> last' xs
            | [] -> raise (Empty_List ())
    in
    last' lst
end

type direction = North | East | South | West

module Turn = struct
  type t = Left | Right

  exception Unsupported_Turn of char

  let from_char s =
    match s with
    | 'R' -> Right
    | 'L' -> Left
    | other -> raise (Unsupported_Turn other)

  let turn_direction ~turn ~direction = match direction with
    | North -> (match turn with
      | Left -> West
      | Right -> East)
    | East -> (match turn with
      | Left -> North
      | Right -> South)
    | South -> (match turn with
      | Left -> East
      | Right -> West)
    | West -> (match turn with
      | Left -> South
      | Right -> North)
end

module Instruction = struct
  type t = Instruction of Turn.t * int

  let from_string s =
    let len = String.length s in
    let turn = Turn.from_char s.[0] in
    let count = int_of_string @@ String.sub s 1 (len - 1) in
    Instruction (turn, count)
end

module Coordinate = struct
  type t = {x: int; y: int}

  let center = {x = 0; y = 0}

  let travel ~direction ~count coord = match direction with
    | North -> {coord with y = coord.y + count}
    | South -> {coord with y = coord.y - count}
    | West -> {coord with x = coord.x - count}
    | East -> {coord with x = coord.x + count}

  let travel_path ~direction ~count coord =
    let rec accumulate direction count coord acc =
      if count = 0 then acc
      else let next = travel ~direction ~count:1 coord in
        accumulate direction (count - 1) next ( next :: acc)
    in
    accumulate direction count coord [] |> List.rev


  let to_blocks {x;y} = abs x + abs y
end

module Location = struct
  type t = Location of Coordinate.t * direction

  let intersect_location a b =
    let eq = fun a b -> match a with
      | Location (coord, _) -> (match b with
          | Location (coord2, _) -> coord = coord2) in
    let candidates = List.filter (fun x -> List.exists (eq x) b) a in
    match candidates with
    | [] -> None
    | x :: xs -> Some x

  let to_blocks = function
    | Location (coord, _) -> Coordinate.to_blocks coord
end

let pinpoint_destination ~document =
  let open Instruction in
  let open Location in
  let walk acc curr =
    match acc with
    | Location (coord, dir) ->
      (match curr with
       | Instruction (turn, count) ->
         let next_direction = Turn.turn_direction ~turn ~direction:dir in
         let next_coord = Coordinate.travel ~direction:next_direction ~count coord in
         Location (next_coord, next_direction))
  in
  let starting_point = Location (Coordinate.center, North) in
  let steps = List.map Instruction.from_string @@ Utils.split ~on:", " document in
  List.fold_left walk starting_point steps
  |> Location.to_blocks

let take_a_taxi ~document =
  let open Instruction in
  let open Location in
  let rec drive current directions visited =
    match directions with
    | x :: xs ->
      (match current with
       | Location (coord, dir) ->
         (match x with
          | Instruction (turn, count) ->
            let next_direction = Turn.turn_direction ~turn ~direction:dir in
            let path = Coordinate.travel_path ~direction:next_direction ~count coord in
            let location_path = List.map (fun coord -> Location (coord, next_direction)) path in
            let next_coord = Utils.last path in
            let next_loc = Location (next_coord, next_direction) in
            let intersected = intersect_location location_path visited in
            match intersected with
            | Some loc -> Location.to_blocks loc
            | None -> drive next_loc xs (List.concat [visited; location_path])))
    | [] -> 0
  in
  let starting_point = Location (Coordinate.center, North) in
  let directions = List.map Instruction.from_string @@ Utils.split ~on:", " document in
  drive starting_point directions [starting_point]
