


(* the value of pi *)
let pi : float =  acos ~-.1.0

(* a function to compare floats that allows for some imprecision *)
let cmp n m = abs_float (n -. m) < 0.0001

(* a simple test of positivity *)
let positive a = a > 0.0

(* a function to check if a is multiple of b *)
let is_multiple_of (a : float) (b : float) : bool =
  let m = a /. b in
  cmp (m -. floor m) 0.0

(* a function to check if a is between plus/minus b *)
let abs_btwn a b = a < b && a > ~-.b


type side = float

type tr_by_sides = side * side * side

type tr_kind
  = Scalene
  | Equilateral
  | Isosceles


let well_formed_by_sides (a, b, c : tr_by_sides) : bool =
  if positive a && positive b && positive c then
    if a+.b > c && b+.c > a && c+.a > b then true
    else false
  else false



let create_triangle (kind : tr_kind) (area : float) : tr_by_sides =
  let e (area:float) = sqrt (2.0 *. area /. sin 1.0472) in
  let iso_side (area:float) = sqrt (4.0 *. area /. sqrt 3.0) in
  let iso_base (area:float) = sqrt (4.0 *. area /. sqrt 3.0) *. sqrt 3.0 in
  let sca_height (area:float) = sqrt (2.0 *. area /. sqrt 3.0) in
  let sca_base (area:float)   = sqrt ((2.0 *. area /. sqrt 3.0) *. sqrt 3.0) in
  let sca_hyp (area:float)    = sqrt (2.0 *. area /. sqrt 3.0) *. 2.0 in
  match kind with
  | Equilateral -> ((e area, e area, e area) : tr_by_sides)
  | Isosceles   -> ((iso_side area, iso_side area, iso_base area) : tr_by_sides)
  | Scalene     -> ((sca_height area, sca_base area, sca_hyp area) : tr_by_sides)

(* Question 2.3 *)
type angle = float

type tr_by_angle = side * side * angle

let well_formed_by_angle (a, b, gamma) : bool =
  (positive a && positive b && positive gamma) &&
    (not (is_multiple_of gamma pi))

let sides_to_angle (a, b, c : tr_by_sides) : tr_by_angle option =
  if well_formed_by_sides (a,b,c) then
    Some (a, b, (acos ((a**2. +. b**2. -. c**2.) /. (2. *. a *. b))))
  else
    None

let angle_to_sides (a, b, gamma) =
  if well_formed_by_angle (a,b,gamma) then
    Some (a, b, sqrt (a**2. +. b**2. -. 2. *. a *. b *. (cos gamma)))
  else
    None



let even (n : int) : bool = n mod 2 = 0


let evens_first (l : int list) : int list =
  let odd n = not (even n) in
  let evens = List.filter even l in 
  let odds  = List.filter odd l in
  evens@odds

let ex_1 = evens_first [7 ; 5 ; 2; 4; 6; 3; 4; 2; 1]
(* val ex_1 : int list = [2; 4; 6; 4; 2; 7; 5; 3; 1] *)


let even_streak (l : int list) : int =
  let rec aux count max = function
    |[]   -> max
    |h::t ->
      if even h then
        if max=count then aux (count+1) (count+1) t
        else aux (count+1) max t
      else aux 0 max t
  in
  aux 0 0 l

let ex_2 = even_streak [7; 2; 4; 6; 3; 4; 2; 1]


(*  D D D D D D D D D D D N N N N N N N N N N N N N A A A A A A A A A A A    *)

type nucleobase = A | G | C | T

let compress (l : nucleobase list) : (int * nucleobase) list =
  let rec aux count acc = function
      | [] -> []
      | [x] -> (count+1, x) :: acc
      | h1 :: (h2 :: _ as t) ->
        if h1=h2 then aux (count + 1) acc t
        else aux 0 ((count+1,h1) :: acc) t in
    List.rev (aux 0 [] l)

let rec decompress (l : (int * nucleobase) list) : nucleobase list =
  let rec many acc n nb =
    if n = 0 then acc else many (nb :: acc) (n-1) nb in
  let rec aux acc = function
    | [] -> acc
    | (n,nb) :: t -> if n=1 then aux (nb::acc) t else aux (many acc n nb) t
  in
  aux [] (List.rev l);;

let sample_dna : nucleobase list = [A;A;A;A;G;G;A;T;T;T;C;T;C]

let ex_3 = compress sample_dna

let ex_4 = decompress ex_3

let res_3_4 = sample_dna = ex_4 (* This should be true if everything went well *)
