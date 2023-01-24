A point P belonging to a BN elliptic curve is of the form `P=(x,y)`, with `x` and `y` belonging to `Fp(t)` and `(x,y)` satisfying the equation `y² = x³ + 3`. 


`Fp(t)` is the finite field over the prime `p(t)`, which is parametrized by a positive integer `t > 36`. 

`p(t) = 36*t⁴ + 36*t³ + 24*t² + 6*t¹ + 1*t⁰` for BN curves. 

For the curve alt_bn128 (also named bn254), `t = t_254 = 4965661367192848881`, which is a 63 bits integer. 
By evaluating P(t_254)=P_bn254, we get that P_bn254 is a 254-bit integer. 

However, the primitive element in Cairo, a field element (`felt`) belonging to `F_stark`, the finite field over the STARK curve's prime (`P_stark`), is bounded between `0` and `P_stark-1`, with `P_stark-1` being a 252-bit integer [1].  
This essentially means that there is not enough values in one Cairo's field element to store all the possible values in `Fp(t_254)`.

Different solutions have been used to represent larger than `P_stark-1` numbers in Cairo, the most famous one being the `Uint256` struct, which is composed of two field elements (the `low` and `high` parts).

To represent a 256-bit number in Cairo, we can split its bit represenation in two 128 bits parts.   
The full `Uint256` number can be retrieved by computing `low + high * 2^¹²⁸`.  
Note that both `low` and `high` are `felt`s of at most 128 bits each and that the full number cannot be represented in Cairo but only reconstructed by someone by doing the computation (or he should just accept to represent numbers like that :)). 


[[1] - https://www.cairo-lang.org/docs/how_cairo_works/cairo_intro.html](https://www.cairo-lang.org/docs/how_cairo_works/cairo_intro.html)
