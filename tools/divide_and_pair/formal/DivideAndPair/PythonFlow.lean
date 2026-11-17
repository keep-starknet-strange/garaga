module

public import DivideAndPair.Generated

-- Generated from the production Python AST. Do not edit.
-- source_sha256: 514bb0fc5fbbe8a4bed0786207ccf5ff14f587b6b6a76115ea67e540c343ce4f
-- extractor_sha256: 96fcfa4dc8f82a337d36f5ef8d242fff8b0512e41d96ead90c51f355be6da3eb
@[expose] public section
namespace DivideAndPair
noncomputable section

abbrev pythonConstant_D : Fp := 37095705934669439343138083508754565189542113879843219016388785533085940283555

abbrev pythonConstant_I : Fp := 19681161376707505956807079304988542015446066515923890162744021073123829784752

abbrev pythonConstant_A : Fp := 16295367250680780974490674513165176452449235426866156013048779062215315747159

abbrev pythonConstant_A_PRIME : Fp := 25305310117296535762804143478013601021736521479087969993631233879525933325631

abbrev pythonConstant_B_PRIME : Fp := 43325195850528045339431081407710450160311093583531597954796143514147168482559

abbrev pythonConstant_SQRT_2_B_PRIME : Fp := 46902340116190997102098187643918485604163952319255431191182728563730867863457

abbrev pythonConstant_SQRT_TWO_I : Fp := 38214883241950591754978413199355411911188925816896391856984770930832735035196

def pythonFlow_sqrt (value : Fp) : Option Fp :=
  let root := (value)^7237005577332262213973186563042994240829374041602535252466099000494570602494
  if decide ((root*root) ≠ value) then
    let root := (root*pythonConstant_I)
    if decide ((root*root) = value) then
      some (root)
    else
      none
  else
    if decide ((root*root) = value) then
      some (root)
    else
      none

def pythonFlow_sqrt_or_twice (value : Fp) : Option (Bool × Fp) :=
  let root := (value)^7237005577332262213973186563042994240829374041602535252466099000494570602494
  let square := (root*root)
  if decide (square = value) then
    some ((true, root))
  else
    if decide (square = (-value)) then
      some ((true, (root*pythonConstant_I)))
    else
      if decide (square = (pythonConstant_I*value)) then
        some ((false, ((root*pythonConstant_SQRT_TWO_I)*pythonConstant_I)))
      else
        if decide (square = ((-pythonConstant_I)*value)) then
          some ((false, (root*pythonConstant_SQRT_TWO_I)))
        else
          none

def pythonFlow_is_on_curve (x y : Fp) : Bool :=
  decide (((((y*y)-(x*x))-1)-((((pythonConstant_D*x)*x)*y)*y)) = 0)

def pythonFlow_is_small_order (x y : Fp) : Bool :=
  decide (((x*y)*((x*x)+(y*y))) = 0)

def pythonBody_is_in_prime_order_subgroup
    (dependency_sqrt : Fp → Option Fp)
    (dependency_sqrt_or_twice : Fp → Option (Bool × Fp))
    (dependency_quartic : Fp → Fp)
    (dependency_is_on_curve dependency_is_small_order : Fp → Fp → Bool)
    (x y : Fp) : Bool :=
  let (x, y) := (x, y)
  if (!dependency_is_on_curve (x) (y)) then
    false
  else
    if dependency_is_small_order (x) (y) then
      (decide (x = 0) && decide (y = 1))
    else
      let e := (x*(1-y))
      let u := (((((-1)-pythonConstant_D)*(1+y))*x)*e)
      let w := (2*(1-y))
      let wp := dependency_sqrt ((4*u))
      match wp with
      | none =>
        false
      | some wp =>
        let up := ((((4*u)-((pythonConstant_A_PRIME*e)*e))-((2*wp)*w))*(2)⁻¹)
        match dependency_sqrt_or_twice (up) with
        | some (is_square, root) =>
          let negative := false
          if is_square then
            let w := root
            let u := ((((w*w)-((pythonConstant_A*e)*e))-(w*wp))*(2)⁻¹)
            if negative then
              let w := (-w)
              let f := (u*((w+((2*pythonConstant_I)*e))^2))
              (decide (f ≠ 0) && decide (dependency_quartic (f) = 1))
            else
              let f := (u*((w+((2*pythonConstant_I)*e))^2))
              (decide (f ≠ 0) && decide (dependency_quartic (f) = 1))
          else
            let wp := (wp*root)
            let w := ((pythonConstant_SQRT_2_B_PRIME*e)*e)
            let e := (e*root)
            let negative := true
            let u := ((((w*w)-((pythonConstant_A*e)*e))-(w*wp))*(2)⁻¹)
            if negative then
              let w := (-w)
              let f := (u*((w+((2*pythonConstant_I)*e))^2))
              (decide (f ≠ 0) && decide (dependency_quartic (f) = 1))
            else
              let f := (u*((w+((2*pythonConstant_I)*e))^2))
              (decide (f ≠ 0) && decide (dependency_quartic (f) = 1))
        | none => false

def pythonFlow_is_in_prime_order_subgroup (x y : Fp) : Bool :=
  pythonBody_is_in_prime_order_subgroup pythonFlow_sqrt pythonFlow_sqrt_or_twice
    (fun f => f^14474011154664524427946373126085988481658748083205070504932198000989141204987) pythonFlow_is_on_curve pythonFlow_is_small_order x y

end
end DivideAndPair
