
type __ = Obj.t
let __ = let rec f _ = Obj.repr f in Obj.repr f

module Nat =
 struct
 end

(** val list_eq_dec : ('a1 -> 'a1 -> bool) -> 'a1 list -> 'a1 list -> bool **)

let rec list_eq_dec eq_dec l l' =
  match l with
  | [] -> (match l' with
           | [] -> true
           | _::_ -> false)
  | y::l0 ->
    (match l' with
     | [] -> false
     | a::l1 -> if eq_dec y a then list_eq_dec eq_dec l0 l1 else false)

(** val seq : int -> int -> int list **)

let rec seq start len =
  (fun fO fS n -> if n=0 then fO () else fS (n-1))
    (fun _ -> [])
    (fun len0 -> start::(seq (Stdlib.Int.succ start) len0))
    len

type baseParams =
| Build_BaseParams

type data = __

type input = __

type output = __

type multiParams = { msg_eq_dec : (__ -> __ -> bool);
                     name_eq_dec : (__ -> __ -> bool); nodes : __ list;
                     init_handlers : (__ -> data);
                     net_handlers : (__ -> __ -> __ -> data -> (output
                                    list * data) * (__ * __) list);
                     input_handlers : (__ -> input -> data -> (output
                                      list * data) * (__ * __) list) }

type ('w, 's, 'o, 'a) genHandler = 's -> (('a * 'o list) * 's) * 'w list

(** val ret : 'a4 -> ('a1, 'a2, 'a3, 'a4) genHandler **)

let ret a s =
  ((a , []) , s) , []

(** val bind :
    ('a1, 'a2, 'a3, 'a4) genHandler -> ('a4 -> ('a1, 'a2, 'a3, 'a5)
    genHandler) -> ('a1, 'a2, 'a3, 'a5) genHandler **)

let bind m f s =
  let p , ws1 = m s in
  let p0 , s' = p in
  let a , os1 = p0 in
  let p1 , ws2 = f a s' in
  let p2 , s'' = p1 in
  let b , os2 = p2 in
  ((b , (List.append os1 os2)) , s'') , (List.append ws1 ws2)

(** val send : 'a1 -> ('a1, 'a2, 'a3, unit) genHandler **)

let send w s =
  ((() , []) , s) , (w::[])

(** val write_output : 'a3 -> ('a1, 'a2, 'a3, unit) genHandler **)

let write_output o s =
  ((() , (o::[])) , s) , []

(** val put : 'a2 -> ('a1, 'a2, 'a3, unit) genHandler **)

let put s _ =
  ((() , []) , s) , []

(** val get : ('a1, 'a2, 'a3, 'a2) genHandler **)

let get s =
  ((s , []) , s) , []

(** val runGenHandler_ignore :
    'a2 -> ('a1, 'a2, 'a3, 'a4) genHandler -> ('a3 list * 'a2) * 'a1 list **)

let runGenHandler_ignore s h =
  let p , ms = h s in let p0 , s' = p in let _ , os = p0 in (os , s') , ms

(** val nop : ('a1, 'a2, 'a3, unit) genHandler **)

let nop x =
  ret () x

type name = int

type vector = (name * int) list

type input0 =
| Local
| Send of name

type data0 = vector
  (* singleton inductive, whose constructor was mkData *)

(** val init_vector : int -> vector **)

let init_vector num_nodes =
  List.map (fun n -> n , 0) ((fun n -> (Obj.magic (seq 0 n))) num_nodes)

(** val nodes0 : int -> int list **)

let nodes0 =
  (fun n -> (Obj.magic (seq 0 n)))

type msg = vector
  (* singleton inductive, whose constructor was Update *)

(** val update_list : int -> vector -> name -> (int -> int) -> vector **)

let rec update_list num_nodes vec n f =
  match vec with
  | [] -> []
  | p::rest ->
    let n' , c = p in
    if (fun _ -> (=)) num_nodes n' n
    then (n' , (f c))::rest
    else (n' , c)::(update_list num_nodes rest n f)

(** val increment : int -> vector -> name -> vector **)

let increment num_nodes vec n =
  update_list num_nodes vec n (fun x -> Stdlib.Int.succ x)

(** val merge : int -> vector -> vector -> vector **)

let rec merge num_nodes v1 v2 =
  match v1 with
  | [] -> v2
  | p::rest1 ->
    let n1 , c1 = p in
    (match v2 with
     | [] -> v1
     | p0::rest2 ->
       let n2 , c2 = p0 in
       if (fun _ -> (=)) num_nodes n1 n2
       then (n1 , (Stdlib.max c1 c2))::(merge num_nodes rest1 rest2)
       else (n1 , c1)::(merge num_nodes rest1 v2))

(** val init_data : int -> data0 **)

let init_data =
  init_vector

(** val name_eq_dec0 : int -> int -> int -> bool **)

let name_eq_dec0 =
  (fun _ -> (=))

(** val msg_eq_dec0 : int -> msg -> msg -> bool **)

let msg_eq_dec0 num_nodes x y =
  list_eq_dec (fun x0 y0 ->
    let a , b = x0 in
    let n , n0 = y0 in if name_eq_dec0 num_nodes a n then (=) b n0 else false)
    x y

type 's handler = (name * msg, 's, __, unit) genHandler

(** val inputHandler : int -> name -> input0 -> data0 -> data0 handler **)

let inputHandler num_nodes n i s =
  bind get (fun _ ->
    let new_vec = increment num_nodes s n in
    bind (put new_vec) (fun _ ->
      bind (write_output __) (fun _ ->
        match i with
        | Local -> nop
        | Send dest -> send (dest , new_vec))))

(** val netHandler : int -> name -> name -> msg -> data0 -> data0 handler **)

let netHandler num_nodes me _ msg0 s =
  bind get (fun _ ->
    let vec_after_increment = increment num_nodes s me in
    let merged = merge num_nodes vec_after_increment msg0 in put merged)

(** val vc_BaseParams : int -> baseParams **)

let vc_BaseParams _ =
  Build_BaseParams

(** val vc_MultiParams : int -> multiParams **)

let vc_MultiParams num_nodes =
  { msg_eq_dec = (Obj.magic msg_eq_dec0 num_nodes); name_eq_dec =
    (name_eq_dec0 num_nodes); nodes = (nodes0 num_nodes); init_handlers =
    (fun _ -> Obj.magic init_data num_nodes); net_handlers =
    (fun me src msg0 s ->
    runGenHandler_ignore s (Obj.magic netHandler num_nodes me src msg0 s));
    input_handlers = (fun nm i s ->
    runGenHandler_ignore s (Obj.magic inputHandler num_nodes nm i s)) }
