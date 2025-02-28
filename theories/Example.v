


Module ABD.
Parameter n : nat.
Parameter Value : Type.

Parameter Label : Type.
Parameter label_lt : Label -> Label -> bool.
Parameter label_eq : Label -> Label -> bool.

Definition Processor := nat.

Inductive Message :=
  | Write : Label -> Value -> Message
  | AckWrite : Message
  | ReadRequest : Message
  | ReadResponse : Label -> Value -> Message
  | AckRead : Message.

Record ProcessorState := {
  val : Label * Value;  
  labels : list (Label * Value); 
}.
End ABD.
