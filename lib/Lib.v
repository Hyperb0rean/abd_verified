From Vecclock Require Import Vecclock.
From Verdi Require Import Verdi.
Require Extraction.

Extract Inductive bool => "bool" [ "true" "false" ].
Extract Inductive list => "list" [ "[]" "(::)" ].
Extract Inductive prod => "( * )" [ "( , )" ]. 

Extraction Language OCaml.

Set Extraction Optimize.

Set Extraction Output Directory "lib".

(* Extraction "libcoq.ml" Vecclock.VectorClock. *)