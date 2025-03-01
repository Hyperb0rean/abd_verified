From Verdi Require Import Verdi.

Require Import Verdi.Core.HandlerMonad.
Require Import StructTact.Fin.
Require Import Vectors.Fin.

Local Arguments update {_} {_} _ _ _ _ _ : simpl never.

Require Import Verdi.Core.StatePacketPacketDecomposition.

Set Implicit Arguments.

Require Import List. Import ListNotations.
Require Import Coq.Logic.FunctionalExtensionality.

Section VectorClock.
  Variable num_nodes : nat.
  Definition Name := fin num_nodes. 

  Definition Vector := Name -> nat.  
  Inductive Input := Event.          
  Inductive Output := Ack.           

  Record Data := mkData { vclock : Vector }.
  Definition init_vector : Vector := fun _ => 0. 

  Definition Nodes := all_fin num_nodes.
  Lemma all_Names_Nodes : forall n, In n Nodes. 
  Proof. 
   apply all_fin_all. 
  Qed.
  
  Lemma NoDup_Nodes : NoDup Nodes. 
  Proof. 
    apply all_fin_NoDup. 
  Qed.

  Inductive Msg := Update (vec : Vector). 

  Definition increment (vec : Vector) (n : Name) : Vector :=
    fun idx => if (fin_eq_dec num_nodes idx n) 
              then S (vec idx) 
              else vec idx.

  Definition merge (v1 v2 : Vector) : Vector :=
    fun idx => max (v1 idx) (v2 idx).

  Definition init_data : Data := mkData init_vector.

  Definition Name_eq_dec := fin_eq_dec num_nodes.
  Definition Msg_eq_dec : forall x y : Msg, {x = y} + {x <> y}.
    decide equality. 
Admitted.

  Definition Handler (S : Type) := GenHandler (Name * Msg) S Output unit.

  Fixpoint send_all_aux (m: Msg) (l: list (fin num_nodes)) : Handler Data :=
  match l with
  | [] => nop
  | dst :: tail => send (dst, m) ;;  (send_all_aux m tail)
  end.

  Definition send_all (m : Msg) : Handler Data :=
    send_all_aux m (all_fin num_nodes).


  Definition InputHandler (n : Name) (i : Input) (s : Data) : Handler Data :=
    d <- get ;;
    let new_vec := increment (vclock s) n in
    put (mkData new_vec) ;;
    write_output Ack ;;
    send_all (Update new_vec).

  Definition NetHandler (me : Name) (src: Name) (msg : Msg) (s : Data) : Handler Data :=
    match msg with
    | Update vec =>
      d <- get ;;
      let vec_after_increment := increment (vclock s) me in  
      let merged := merge vec_after_increment vec in
      put (mkData merged)
    end.

  #[global]
  Instance Vc_BaseParams : BaseParams :=
    {
      data := Data;
      input := Input;
      output := Output
    }.

  #[global]
  Instance Vc_MultiParams : MultiParams Vc_BaseParams :=
    {
      name := Name;
      name_eq_dec := Name_eq_dec;
      msg := Msg;
      msg_eq_dec := Msg_eq_dec;
      nodes := Nodes;
      all_names_nodes := all_Names_Nodes;
      no_dup_nodes := NoDup_Nodes;
      init_handlers := fun _ => init_data;
      net_handlers := fun me src msg s =>
                        runGenHandler_ignore s (NetHandler me src msg s);
      input_handlers := fun nm i s =>
                        runGenHandler_ignore s (InputHandler nm i s)
    }.

End VectorClock.