
type nat =
| O
| S of nat



module ABD =
 struct
  (** val n : nat **)

  let n =
    failwith "AXIOM TO BE REALIZED (ABD.Example.ABD.n)"

  type coq_Value (* AXIOM TO BE REALIZED *)

  type coq_Label (* AXIOM TO BE REALIZED *)

  (** val label_lt : coq_Label -> coq_Label -> bool **)

  let label_lt =
    failwith "AXIOM TO BE REALIZED (ABD.Example.ABD.label_lt)"

  (** val label_eq : coq_Label -> coq_Label -> bool **)

  let label_eq =
    failwith "AXIOM TO BE REALIZED (ABD.Example.ABD.label_eq)"

  type coq_Processor = nat

  type coq_Message =
  | Write of coq_Label * coq_Value
  | AckWrite
  | ReadRequest
  | ReadResponse of coq_Label * coq_Value
  | AckRead

  (** val coq_Message_rect :
      (coq_Label -> coq_Value -> 'a1) -> 'a1 -> 'a1 -> (coq_Label ->
      coq_Value -> 'a1) -> 'a1 -> coq_Message -> 'a1 **)

  let coq_Message_rect f f0 f1 f2 f3 = function
  | Write (l, v) -> f l v
  | AckWrite -> f0
  | ReadRequest -> f1
  | ReadResponse (l, v) -> f2 l v
  | AckRead -> f3

  (** val coq_Message_rec :
      (coq_Label -> coq_Value -> 'a1) -> 'a1 -> 'a1 -> (coq_Label ->
      coq_Value -> 'a1) -> 'a1 -> coq_Message -> 'a1 **)

  let coq_Message_rec f f0 f1 f2 f3 = function
  | Write (l, v) -> f l v
  | AckWrite -> f0
  | ReadRequest -> f1
  | ReadResponse (l, v) -> f2 l v
  | AckRead -> f3

  type coq_ProcessorState = { coq_val : (coq_Label * coq_Value);
                              labels : (coq_Label * coq_Value) list }

  (** val coq_val : coq_ProcessorState -> coq_Label * coq_Value **)

  let coq_val p =
    p.coq_val

  (** val labels : coq_ProcessorState -> (coq_Label * coq_Value) list **)

  let labels p =
    p.labels
 end
