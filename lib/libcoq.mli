
type nat =
| O
| S of nat



module ABD :
 sig
  val n : nat

  type coq_Value (* AXIOM TO BE REALIZED *)

  type coq_Label (* AXIOM TO BE REALIZED *)

  val label_lt : coq_Label -> coq_Label -> bool

  val label_eq : coq_Label -> coq_Label -> bool

  type coq_Processor = nat

  type coq_Message =
  | Write of coq_Label * coq_Value
  | AckWrite
  | ReadRequest
  | ReadResponse of coq_Label * coq_Value
  | AckRead

  val coq_Message_rect :
    (coq_Label -> coq_Value -> 'a1) -> 'a1 -> 'a1 -> (coq_Label -> coq_Value
    -> 'a1) -> 'a1 -> coq_Message -> 'a1

  val coq_Message_rec :
    (coq_Label -> coq_Value -> 'a1) -> 'a1 -> 'a1 -> (coq_Label -> coq_Value
    -> 'a1) -> 'a1 -> coq_Message -> 'a1

  type coq_ProcessorState = { coq_val : (coq_Label * coq_Value);
                              labels : (coq_Label * coq_Value) list }

  val coq_val : coq_ProcessorState -> coq_Label * coq_Value

  val labels : coq_ProcessorState -> (coq_Label * coq_Value) list
 end
