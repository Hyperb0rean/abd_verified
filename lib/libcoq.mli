
type __ = Obj.t

module Nat :
 sig
 end

val list_eq_dec : ('a1 -> 'a1 -> bool) -> 'a1 list -> 'a1 list -> bool

val seq : int -> int -> int list

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

val ret : 'a4 -> ('a1, 'a2, 'a3, 'a4) genHandler

val bind :
  ('a1, 'a2, 'a3, 'a4) genHandler -> ('a4 -> ('a1, 'a2, 'a3, 'a5) genHandler)
  -> ('a1, 'a2, 'a3, 'a5) genHandler

val send : 'a1 -> ('a1, 'a2, 'a3, unit) genHandler

val write_output : 'a3 -> ('a1, 'a2, 'a3, unit) genHandler

val put : 'a2 -> ('a1, 'a2, 'a3, unit) genHandler

val get : ('a1, 'a2, 'a3, 'a2) genHandler

val runGenHandler_ignore :
  'a2 -> ('a1, 'a2, 'a3, 'a4) genHandler -> ('a3 list * 'a2) * 'a1 list

val nop : ('a1, 'a2, 'a3, unit) genHandler

type name = int

type vector = (name * int) list

type input0 =
| Local
| Send of name

type data0 = vector
  (* singleton inductive, whose constructor was mkData *)

val init_vector : int -> vector

val nodes0 : int -> int list

type msg = vector
  (* singleton inductive, whose constructor was Update *)

val update_list : int -> vector -> name -> (int -> int) -> vector

val increment : int -> vector -> name -> vector

val merge : int -> vector -> vector -> vector

val init_data : int -> data0

val name_eq_dec0 : int -> int -> int -> bool

val msg_eq_dec0 : int -> msg -> msg -> bool

type 's handler = (name * msg, 's, __, unit) genHandler

val inputHandler : int -> name -> input0 -> data0 -> data0 handler

val netHandler : int -> name -> name -> msg -> data0 -> data0 handler

val vc_BaseParams : int -> baseParams

val vc_MultiParams : int -> multiParams
