From Verdi Require Import Verdi.

Require Import Verdi.Core.HandlerMonad.
Require Import StructTact.Fin.
Require Import Vectors.Fin.

Local Arguments update {_} {_} _ _ _ _ _ : simpl never.

Require Import Verdi.Core.StatePacketPacketDecomposition.

Set Implicit Arguments.

Require Import List. Import ListNotations.

Section VectorClock.
  Variable num_nodes : nat.               (* Total number of nodes *)
  Definition NodeIndex := fin num_nodes.  (* Finite node indices *)

  (* Vector clock: function from node indices to counters *)
  Definition Vector := NodeIndex -> nat.
  Definition init_vector : Vector := fun _ => 0.

  (* Per-node state containing its vector clock *)
  Record NodeState := mkNodeState { my_vector : Vector }.
  Definition init_node_state : NodeState := mkNodeState init_vector.

  (* Messages carry the sender's vector clock *)
  Inductive Msg := VC (sender : NodeIndex) (vec : Vector).

  (* Handler utilities *)
  Definition increment_clock (vec : Vector) (self : NodeIndex) : Vector :=
    fun idx  => if (fin_eq_dec num_nodes idx self) 
              then S (vec idx) 
              else vec idx.

  Definition merge_vec (v1 v2 : Vector) : Vector :=
    fun idx => max (v1 idx) (v2 idx).

  Definition local_handler (self : NodeIndex) (st : NodeState) : NodeState :=
    mkNodeState (increment_clock (my_vector st) self).

  Definition send_handler (self : NodeIndex) (st : NodeState) : (Msg * NodeState) :=
    (VC self (my_vector st), local_handler self st).

  Definition recv_handler (self : NodeIndex) (msg : Msg) (st : NodeState) : NodeState :=
    match msg with
    | VC sender vec =>
      mkNodeState (increment_clock 
        (merge_vec (my_vector st) vec) self)
    end.

End VectorClock.