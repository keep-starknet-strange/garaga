module

public import DivideAndPair.Generated

-- Generated from the Cairo compiler AST. Do not edit.
-- source_sha256: dc8af7250ee1a47e0bf534c86493b94b49551f60dfdf274e3081e73e4ca4acd3
-- syntax_tree_sha256: f3e11e6fb6a4b758bed92682ca167a157b9ea8cba713da6f6b3e30f8240973ff
-- tool_sha256: {'scarb': 'fc5ec751cb5e495f85c4e77da61a587845ae3c2354999b0dc31c56bfb9f5fc45', 'scarb-cairo-language-server': '6d054d42e021c40d763232f4bc2341a681bcbfdbdf2caedc22553da219b96422'}
-- curve_source_sha256: faafb41371c3e84e649c36c9c97594f7b80e8119f4881097850a043d2de1c6d9
-- curve_ast_sha256: 842d30b5b10b6d2958cff7fc917d3c4e3a16c8e5778f699c3ec52b5dbf004ff6
-- extractor_sha256: de9ee3eca28aaf213ed5372f055846ba7aaff7da0b5baa00efaa23d28f150aa8
@[expose] public section
namespace DivideAndPair
noncomputable section

abbrev cairoConstant_SQRT_MINUS_ONE : Fp := 19681161376707505956807079304988542015446066515923890162744021073123829784752

abbrev cairoConstant_MINUS_ONE : Fp := 57896044618658097711785492504343953926634992332820282019728792003956564819948

abbrev cairoConstant_SQRT_TWO_I : Fp := 38214883241950591754978413199355411911188925816896391856984770930832735035196

abbrev cairoConstant_I_SQRT_TWO_I : Fp := 38214883241950591754978413199355411911188925816896391856984770930832735035198

abbrev cairoCurve_p : Nat := 57896044618658097711785492504343953926634992332820282019728792003956564819949

abbrev cairoCurve_a : Fp := 42204101795669822316448953119945047945709099015225996174933988943478124189485

abbrev cairoCurve_b : Fp := 13148341720542919587570920744190446479425344491440436116213316435534172959396

abbrev cairoCurve_n : Nat := 7237005577332262213973186563042994240857116359379907606001950938285454250989

def cairoFlow_is_small_order_edwards (x y : Fp) : Bool :=
  if (decide (x = 0) || decide (y = 0)) then
    true
  else
    let check : Fp := (cairo_low_order (x) (y))[0]!
    decide (check = 0)

def cairoFlow_sqrt (value : Fp) : Option Fp :=
  let root : Fp := (cairo_sqrt (value))[0]!
  let same : Fp := (cairo_sqrt (value))[1]!
  let opposite : Fp := (cairo_sqrt (value))[2]!
  if decide (same = 0) then
    some (root)
  else
    if decide (opposite = 0) then
      some ((root*cairoConstant_SQRT_MINUS_ONE))
    else
      none

def cairoFlow_sqrt_or_twice (value : Fp) : Option (Bool × Fp) :=
  let root : Fp := (cairo_sqrt_or_twice (value))[0]!
  let same : Fp := (cairo_sqrt_or_twice (value))[1]!
  let opposite : Fp := (cairo_sqrt_or_twice (value))[2]!
  let imaginary : Fp := (cairo_sqrt_or_twice (value))[3]!
  let neg_imaginary : Fp := (cairo_sqrt_or_twice (value))[4]!
  let _modulus := ()
  if decide (same = 0) then
    some ((true, root))
  else
    if decide (opposite = 0) then
      some ((true, (root*cairoConstant_SQRT_MINUS_ONE)))
    else
      if decide (imaginary = 0) then
        some ((false, (root*cairoConstant_I_SQRT_TWO_I)))
      else
        if decide (neg_imaginary = 0) then
          some ((false, (root*cairoConstant_SQRT_TWO_I)))
        else
          none

def cairoBody_is_in_prime_order_subgroup_edwards
    (dependency_is_small_order_edwards : Fp → Fp → Bool)
    (dependency_sqrt : Fp → Option Fp)
    (dependency_sqrt_or_twice : Fp → Option (Bool × Fp))
    (dependency_finish : Fp → Fp → Fp → Fp → List Fp)
    (x y : Fp) : Bool :=
  if dependency_is_small_order_edwards (x) (y) then
    (decide (x = 0) && decide (y = 1))
  else
    let u : Fp := (cairo_prepare (x) (y))[0]!
    let w : Fp := (cairo_prepare (x) (y))[1]!
    let e : Fp := (cairo_prepare (x) (y))[2]!
    let _modulus := ()
    let four_u := (u*4)
    match dependency_sqrt (four_u) with
    | some root =>
      let wp := root
      let up : Fp := (cairo_halve_up (u) (w) (e) (wp))[0]!
      match dependency_sqrt_or_twice (up) with
      | some pair =>
        let (is_square, root) := pair
        if is_square then
          let (w, sign) := (root, (1 : Fp))
          let quartic : Fp := (dependency_finish (e) (wp) (w) (sign))[0]!
          decide (quartic = 1)
        else
          let next_e : Fp := (cairo_halve_nqr (e) (wp) (root))[0]!
          let next_wp : Fp := (cairo_halve_nqr (e) (wp) (root))[1]!
          let next_w : Fp := (cairo_halve_nqr (e) (wp) (root))[2]!
          let e := next_e
          let wp := next_wp
          let (w, sign) := (next_w, cairoConstant_MINUS_ONE)
          let quartic : Fp := (dependency_finish (e) (wp) (w) (sign))[0]!
          decide (quartic = 1)
      | none =>
        false
    | none =>
      false

def cairoFlow_is_in_prime_order_subgroup_edwards (x y : Fp) : Bool :=
  cairoBody_is_in_prime_order_subgroup_edwards cairoFlow_is_small_order_edwards
    cairoFlow_sqrt cairoFlow_sqrt_or_twice cairo_finish x y

end
end DivideAndPair
