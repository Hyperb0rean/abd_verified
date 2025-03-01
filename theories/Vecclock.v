From Verdi Require Import Verdi.

Require Import Verdi.Core.HandlerMonad.
Require Import StructTact.Fin.
Require Import Vectors.Fin.

Local Arguments update {_} {_} _ _ _ _ _ : simpl never.

Require Import Verdi.Core.StatePacketPacketDecomposition.

Set Implicit Arguments.

Require Import List. Import ListNotations.

Section VectorClock.
  Variable num_nodes : nat.
  Definition Name := fin num_nodes. 

  Definition Vector := list (Name * nat).
  
  Inductive Input := 
  | Local
  | Send (dest: Name).          
  Inductive Output := Ack.           

  Record Data := mkData { vclock : Vector }.

  Definition init_vector : Vector :=
    List.map (fun n => (n, 0)) (all_fin num_nodes).

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

  Fixpoint update_list (vec : Vector) (n : Name) (f : nat -> nat) : Vector :=
    match vec with
    | [] => []
    | (n', c) :: rest =>
      if fin_eq_dec num_nodes n' n
      then (n', f c) :: rest
      else (n', c) :: update_list rest n f
    end.

  Definition increment (vec : Vector) (n : Name) : Vector :=
    update_list vec n S.

  Fixpoint merge (v1 v2 : Vector) : Vector :=
    match v1, v2 with
    | [], _ => v2
    | _, [] => v1
    | (n1, c1) :: rest1, (n2, c2) :: rest2 =>
      if fin_eq_dec num_nodes n1 n2
      then (n1, max c1 c2) :: merge rest1 rest2
      else (n1, c1) :: merge rest1 v2 
    end.

  Definition init_data : Data := mkData init_vector.

  Definition Name_eq_dec := fin_eq_dec num_nodes.

  Definition Msg_eq_dec : forall x y : Msg, {x = y} + {x <> y}.
    decide equality.
    apply list_eq_dec.
    decide equality.
    - apply Nat.eq_dec.
    - apply Name_eq_dec.
  Defined.

  Definition Handler (S : Type) := GenHandler (Name * Msg) S Output unit.

  Definition InputHandler (n : Name) (i : Input) (s : Data) : Handler Data :=
    d <- get ;;
    let new_vec := increment (vclock s) n in 
    put (mkData new_vec) ;;
    write_output Ack ;;
    match i with
    | Local => nop
    | Send dest => send (dest, Update new_vec)
    end.

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


  Definition vector_NoDup (vec: Vector) := NoDup (List.map fst vec).

  Definition vector_In (vec: Vector) := 
  (forall n, In n (all_fin num_nodes) -> In n (List.map fst vec)).

  Definition vector_complete (vec : Vector) : Prop :=
     vector_NoDup vec /\ vector_In vec.

  Lemma increment_NoDup: 
    forall vec n,
      vector_NoDup vec ->
      vector_NoDup (increment vec n).
  Proof.
    intros.
    unfold vector_NoDup in H.
    apply NoDup_map_inv in H.
    unfold increment; unfold update_list.
    induction vec; auto.
    - unfold vector_NoDup.
      unfold map. apply NoDup_nil.
    -  apply NoDup_cons_iff in H.
       destruct H.
       apply IHvec in H0.
       clear IHvec.
       destruct a.
       destruct (fin_eq_dec num_nodes n0 n).
       -- unfold vector_NoDup.
  Admitted.

  Lemma increment_In:
    forall vec n,
      vector_In vec ->
      vector_In (increment vec n).
  Proof.
    unfold vector_In.
    intros v n.
    intros HIn.
    induction v; auto.
  Admitted.

  Lemma increment_complete:
    forall vec n,
      vector_complete vec ->
      vector_complete (increment vec n).
  Proof.
      unfold vector_complete.
      split; destruct H.
      - apply increment_NoDup. auto.
      - apply increment_In. auto.
  Qed.


    


End VectorClock.