From Verdi Require Import Verdi.

Require Import Verdi.Core.HandlerMonad.
Require Import StructTact.Fin.

Local Arguments update {_} {_} _ _ _ _ _ : simpl never.

Require Import Verdi.Core.StatePacketPacketDecomposition.

Set Implicit Arguments.

Module ABD.
Parameter num_processors : nat.
Parameter Value : Type.

Parameter Label : Type.
Parameter label_lt : Label -> Label -> bool.
Parameter label_eq : Label -> Label -> bool.

Definition Processor := (fin num_processors).

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

Record GlobalState := {
  processors : list (Processor * ProcessorState);
}.

End ABD.
