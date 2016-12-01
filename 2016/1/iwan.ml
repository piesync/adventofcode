module Utils = struct
  let split ~on str = Str.split (Str.regexp on) str
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

  let to_blocks {x;y} = abs x + abs y
end

type location = Location of Coordinate.t * direction


let step acc curr = let open Instruction in
  match acc with
  | Location (coord, dir) ->
    (match curr with
     | Instruction (turn, count) ->
       let next_direction = Turn.turn_direction ~turn ~direction:dir in
       let next_coord = Coordinate.travel ~direction:next_direction ~count coord in
       Location (next_coord, next_direction))

let pinpoint_destination ~document =
  let starting_point = Location (Coordinate.center, North) in
  let steps = List.map Instruction.from_string @@ Utils.split ~on:", " document in
  let destination = List.fold_left step starting_point steps in
  match destination with
   | Location (coord, _) -> Coordinate.to_blocks coord
