From Vecclock Require Import Vecclock.
From Verdi Require Import Verdi.
Require Extraction.

Require Import ExtrOcamlBasic.
Require Import ExtrOcamlNatInt.

Require Import Verdi.Extraction.ExtrOcamlBasicExt.
Require Import Verdi.Extraction.ExtrOcamlList.
Require Import Verdi.Extraction.ExtrOcamlFinInt.

Extract Inductive bool => "bool" [ "true" "false" ].
Extract Inductive list => "list" [ "[]" "(::)" ].
Extract Inductive prod => "( * )" [ "( , )" ]. 

Extraction Language OCaml.

Set Extraction Optimize.

Set Extraction Output Directory "lib".

Extraction "libcoq.ml" seq Vc_BaseParams Vc_MultiParams.