---
icon: pen-field
---

# ECDSA, Schnorr & EdDSA Signatures

All three signature schemes follow a similar pattern with a Cairo struct containing the signature data and hints for efficient verification. Garaga provides tooling in Python/Rust/Javascript to generate the full expected Cairo struct given signature information.

All signature verification schemes work with all [#supported-elliptic-curves](./#supported-elliptic-curves "mention") in Garaga (except EdDSA which is specific to Ed25519), using the corresponding curve identifier.

## Cairo Verification Functions

Verification functions take the public key as a separate parameter:
- `is_valid_ecdsa_signature_assuming_hash(signature, public_key, curve_id)`
- `is_valid_schnorr_signature_assuming_hash(signature, public_key, curve_id)`
- `is_valid_eddsa_signature(signature, Py_twisted)`

**Important:** The ECDSA and Schnorr verification functions assume that the message hash has been correctly computed by the caller. They verify the signature equation but do not hash the message themselves.

All calldata builders support an optional `prepend_public_key` / `prependPublickey` parameter (default: `true`) to include the public key in the calldata, or set to `false` if you're providing it separately.


### ECDSA Signature verification

#### Usage

The ECDSA verification function now takes the public key as a separate parameter:

<pre class="language-rust"><code class="lang-rust"><strong>use garaga::signatures::ecdsa::{ECDSASignatureWithHint, is_valid_ecdsa_signature_assuming_hash}
</strong><strong>use garaga::definitions::{G1Point, u384};
</strong><strong>
</strong><strong>fn test_ecdsa_SECP256R1() {
</strong>    // Deserialize the public key
    let public_key = G1Point {
        x: u384 {
            limb0: 34694928290549184974602577388,
            limb1: 35759716824491418078524634570,
            limb2: 2594220943088396205,
            limb3: 0
        },
        y: u384 {
            limb0: 9226838507146212881830906405,
            limb1: 35599072040218352966556527616,
            limb2: 598080914078199897,
            limb3: 0
        }
    };

    // Deserialize the signature with hints
    let mut ecdsa_sig_with_hints_serialized = array![
        21874539732133939463284150966,
        14029340955433018791294131747,
        3039015141884314015,
        0,
        95584858686408643695335033202448863027,
        295568637128703506613014171176624311464,
        1,
        5334448378619112049701259704,
        41385154388772315182663277631,
        17712994706362733847,
        0,
        29943553562302403413545215534,
        33037261117876012390232157188,
        8918362541136268122,
        0,
        312458951358162775936600420074706364003,
        329325272347819381495408738591077500473,
        3833394020842812355998990406,
        66765700634157051574539132101,
        4477689110025533055,
        0,
        75284665963514526184804770112,
        28452176180126880360930482015,
        1579620003966434192,
        0,
        19499707649242955118980329915,
        5878866304733615882729982833,
        5158977627283021473,
        0,
        75518011646420577994275807341,
        13893298605530609747468498833,
        10742719509567339089,
        0,
        24293114043510796139220306105,
        25376390012297242252015385975,
        17844466804537668387,
        0,
        78485570360506783502329963418,
        69567083500297929201016982522,
        13719673485863094269,
        0,
        5,
        55354569233353773037253712798,
        2056773405300266141020955657,
        14695295204051628183,
        0,
        3734118853538408124826646789,
        25626984397606698678535073594,
        18351971725345451751,
        0,
        49495434377272497377313798575,
        34851998146885742912534842072,
        3023926778795819371,
        0,
        48190150058533943338348412004,
        70504127472473290996773487433,
        2895707273174826071,
        0,
        50328691576807560884872210071,
        56522212629123630038935847222,
        17874133397124150518,
        0,
        6,
        31081889400586212919901398479,
        7665568851851231448697801087,
        3609143467424728178,
        0,
        50406766585718430783387513884,
        41357959349777550509767504129,
        6137493258393505518,
        0,
        26377387688813140318727158733,
        47367686402393074782762130477,
        5938074951439145788,
        0,
        70492859367413630086425830961,
        41967678366660855839107513691,
        12629447670291576441,
        0,
        12056331602681584446883559669,
        21297725337276272546148745365,
        2429236632422096991,
        0,
        1,
        0,
        0,
        0,
        6,
        75493151231231143560331306674,
        18131741189428569100322813289,
        1933502658664370085,
        0,
        15286380581774714888324562528,
        72394024353061184275603912928,
        11440811368481832497,
        0,
        75844427829704858429734784814,
        47671224357920845475667658728,
        2567539314482033183,
        0,
        28456194818149068927928903764,
        4245417196974741482222873405,
        5883152860308569180,
        0,
        40268555471940461921258622684,
        52734928325416522142876152545,
        14276749449010568762,
        0,
        14871523031298562147146295961,
        29600927708016202648484243826,
        15007579434185465358,
        0,
        9,
        75101050097323351430690584795,
        6778053303756606476063947195,
        4493429478205274929,
        0,
        32922720977927181841423278226,
        55973138792226196859208935165,
        11278057686663492522,
        0,
        46421625875767945620138158350,
        12925647827036056682984775590,
        3783907960516859587,
        0,
        78287445063126396814887338264,
        8022378635909900878274988360,
        4052342499575179603,
        0,
        13908384710403740530621807039,
        64748714514032726811375936883,
        16075163882996470199,
        0,
        53444511406060270540633616697,
        39157318819978699367008821534,
        5191339767660252678,
        0,
        70492859367413630086425830958,
        41967678366660855839107513691,
        12629447670291576441,
        0,
        12056331602681584446883559669,
        21297725337276272546148745365,
        2429236632422096991,
        0,
        1,
        0,
        0,
        0,
        9226838507146212881830906405,
        35599072040218352966556527616,
        598080914078199897,
        0,
    ]
        .span();
    let ecdsa_with_hints = Serde::&#x3C;
        ECDSASignatureWithHint,
    >::deserialize(ref ecdsa_sig_with_hints_serialized)
        .unwrap();

    // Verify the signature with the public key as a separate parameter
    let is_valid = is_valid_ecdsa_signature_assuming_hash(ecdsa_with_hints, public_key, 3);
    assert!(is_valid);
}
</code></pre>

#### Calldata generation

Pass your signature information to generate the calldata that you can deserialize inside Cairo into the `ECDSASignatureWithHint` struct. All three implementations (Python/Rust/JavaScript) are equivalent.

{% tabs %}
{% tab title="Python" %}
```python
from garaga.starknet.tests_and_calldata_generators.signatures import ECDSASignature
from garaga.definitions import CurveID

sig = ECDSASignature(r=..., s=..., v=..., px=..., py=..., z=..., curve_id=CurveID.SECP256K1)
calldata = sig.serialize_with_hints()
# Or without public key: sig.serialize_with_hints(prepend_public_key=False)
```
See [signatures.py](https://github.com/keep-starknet-strange/garaga/blob/d23e117a8b861488a47bd5530137c366322750d8/hydra/garaga/starknet/tests_and_calldata_generators/signatures.py#L258)
{% endtab %}

{% tab title="Rust" %}
```rust
use garaga_rs::calldata::signatures::ecdsa_calldata_builder;

let calldata = ecdsa_calldata_builder(r, s, v, px, py, z, true, curve_id)?;
// Or without public key: ecdsa_calldata_builder(r, s, v, px, py, z, false, curve_id)?;
```
See [signatures.rs](https://github.com/keep-starknet-strange/garaga/blob/d23e117a8b861488a47bd5530137c366322750d8/tools/garaga_rs/src/calldata/signatures.rs#L123)
{% endtab %}

{% tab title="Javascript" %}
```typescript
import { ecdsaCalldataBuilder, CurveId } from 'garaga_ts';

const calldata = ecdsaCalldataBuilder(r, s, v, px, py, z, true, CurveId.SECP256K1);
// Or without public key: ecdsaCalldataBuilder(r, s, v, px, py, z, false, CurveId.SECP256K1);
```
See [api.ts](https://github.com/keep-starknet-strange/garaga/blob/d23e117a8b861488a47bd5530137c366322750d8/tools/npm/garaga_ts/src/node/api.ts#L194)
{% endtab %}
{% endtabs %}



### Schnorr Signature verification

#### Usage

The Schnorr verification function now takes the public key as a separate parameter:

```rust
use garaga::signatures::schnorr::{
    SchnorrSignatureWithHint, is_valid_schnorr_signature_assuming_hash,
};
use garaga::definitions::{G1Point, u384};

fn test_schnorr_BN254() {
    // Deserialize the public key
    let public_key = G1Point {
        x: u384 {
            limb0: 28610756795125421341789836686,
            limb1: 867082125726060679479563787,
            limb2: 517675042607557601,
            limb3: 0
        },
        y: u384 {
            limb0: 74669468252610898339759914706,
            limb1: 72459310451373670527166081349,
            limb2: 567344248591793433,
            limb3: 0
        }
    };

    // Deserialize the signature with hints
    let mut sch_sig_with_hints_serialized = array![
        25818539331857930040314617978,
        78090694603461972387174096825,
        2703818907845027019,
        0,
        181762454779927841107875196039457683983,
        28215594864971818583502469914456645564,
        25093249062797173789773481043814634714,
        28090073083341299544504024785600791580,
        28610756795125421341789836686,
        867082125726060679479563787,
        517675042607557601,
        0,
        74669468252610898339759914706,
        72459310451373670527166081349,
        567344248591793433,
        0,
        38325661348877783211976497530,
        35462761860755869492142061064,
        2290891383729020262,
        0,
        41888403965386499220509717377,
        24880030827500007371349674511,
        166822982240436033,
        0,
        18491090926730934087002805824,
        67882993143769697893850332707,
        1614341497221428780,
        0,
        0,
    ]
        .span(); // NOTE : This was shortened for conciseness, this won't work, actual
                 // Array is larger !
    let sch_with_hints = Serde::<
        SchnorrSignatureWithHint,
    >::deserialize(ref sch_sig_with_hints_serialized)
        .unwrap();

    // Verify the signature with the public key as a separate parameter
    let is_valid = is_valid_schnorr_signature_assuming_hash(sch_with_hints, public_key, 0);
    assert!(is_valid);
}
```



#### Calldata generation

Pass your signature information to generate the calldata that you can deserialize inside Cairo into the `SchnorrSignatureWithHint` struct. All three implementations (Python/Rust/JavaScript) are equivalent.

{% tabs %}
{% tab title="Python" %}
```python
from garaga.starknet.tests_and_calldata_generators.signatures import SchnorrSignature
from garaga.definitions import CurveID

sig = SchnorrSignature(rx=..., s=..., e=..., px=..., py=..., curve_id=CurveID.BN254)
calldata = sig.serialize_with_hints()
# Or without public key: sig.serialize_with_hints(prepend_public_key=False)
```
See [signatures.py](https://github.com/keep-starknet-strange/garaga/blob/d23e117a8b861488a47bd5530137c366322750d8/hydra/garaga/starknet/tests_and_calldata_generators/signatures.py#L93)
{% endtab %}

{% tab title="Rust" %}
```rust
use garaga_rs::calldata::signatures::schnorr_calldata_builder;

let calldata = schnorr_calldata_builder(rx, s, e, px, py, true, curve_id)?;
// Or without public key: schnorr_calldata_builder(rx, s, e, px, py, false, curve_id)?;
```
See [signatures.rs](https://github.com/keep-starknet-strange/garaga/blob/d23e117a8b861488a47bd5530137c366322750d8/tools/garaga_rs/src/calldata/signatures.rs#L39)
{% endtab %}

{% tab title="Javascript" %}
```typescript
import { schnorrCalldataBuilder, CurveId } from 'garaga_ts';

const calldata = schnorrCalldataBuilder(rx, s, e, px, py, true, CurveId.BN254);
// Or without public key: schnorrCalldataBuilder(rx, s, e, px, py, false, CurveId.BN254);
```
See [api.ts](https://github.com/keep-starknet-strange/garaga/blob/d23e117a8b861488a47bd5530137c366322750d8/tools/npm/garaga_ts/src/node/api.ts#L145)
{% endtab %}
{% endtabs %}



### EdDSA Signature verification (Ed25519)

EdDSA signatures use the Ed25519 curve following RFC 8032.

#### Usage

```rust
use garaga::signatures::eddsa_25519::{EdDSASignatureWithHint, is_valid_eddsa_signature};
use garaga::definitions::u384;

fn test_eddsa_ed25519() {
    // Public key (Py_twisted) - compressed y-coordinate in twisted Edwards form
    let Py_twisted: u256 = 0x3d4017c3e843895a92b70aa74d1b7ebc9c982ccf2ec4968cc0cd55f12af4660c;

    // Deserialize the signature with hints
    let mut eddsa_sig_with_hints_serialized = array![
        // Ry_twisted (compressed signature R point y-coordinate)
        12345678901234567890,
        98765432109876543210,
        // s (signature scalar)
        11111111111111111111,
        22222222222222222222,
        // Message length
        13,
        // Message bytes
        72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33,
        // MSM hint and sqrt hints...
        // (additional hint data for efficient verification)
    ]
        .span();

    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .unwrap();

    // Verify the signature with the public key as a separate parameter
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, Py_twisted);
    assert!(is_valid);
}
```

#### Calldata generation

Pass your signature information to generate the calldata that you can deserialize inside Cairo into the `EdDSASignatureWithHint` struct. All three implementations (Python/Rust/JavaScript) are equivalent.

{% tabs %}
{% tab title="Python" %}
```python
from garaga.starknet.tests_and_calldata_generators.signatures import EdDSA25519Signature

message = b"Hello, World!"
sig = EdDSA25519Signature(
    Ry_twisted=0x123...,  # Compressed R point (little-endian)
    s=0x456...,           # Signature scalar
    Py_twisted=0x789...,  # Public key (little-endian)
    msg=message
)
calldata = sig.serialize_with_hints()
# Or without public key: sig.serialize_with_hints(prepend_public_key=False)
```
See [signatures.py](https://github.com/keep-starknet-strange/garaga/blob/d23e117a8b861488a47bd5530137c366322750d8/hydra/garaga/starknet/tests_and_calldata_generators/signatures.py#L345)
{% endtab %}

{% tab title="Rust" %}
```rust
use garaga_rs::calldata::signatures::eddsa_calldata_builder;

let message = b"Hello, World!".to_vec();
let calldata = eddsa_calldata_builder(ry_twisted, s, py_twisted, message, true)?;
// Or without public key: eddsa_calldata_builder(ry_twisted, s, py_twisted, message, false)?;
```
See [signatures.rs](https://github.com/keep-starknet-strange/garaga/blob/d23e117a8b861488a47bd5530137c366322750d8/tools/garaga_rs/src/calldata/signatures.rs#L201)
{% endtab %}

{% tab title="Javascript" %}
```typescript
import { eddsaCalldataBuilder } from 'garaga_ts';

const message = new Uint8Array([72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]);
const calldata = eddsaCalldataBuilder(ry_twisted_le, s, py_twisted_le, message, true);
// Or without public key: eddsaCalldataBuilder(ry_twisted_le, s, py_twisted_le, message, false);
```
See [api.ts](https://github.com/keep-starknet-strange/garaga/blob/d23e117a8b861488a47bd5530137c366322750d8/tools/npm/garaga_ts/src/node/api.ts#L236)
{% endtab %}
{% endtabs %}
