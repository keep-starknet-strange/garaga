---
icon: arrow-down-to-bracket
---

# Using garaga libraries in your Cairo project

You can import Garaga's Cairo library by adding this dependency to your `Scarb.toml` file for you project. \


{% code title="Scarb.toml" %}
```toml
[dependencies]
garaga = { git = "https://github.com/keep-starknet-strange/garaga.git" }

[cairo]
sierra-replace-ids = false # Do not forget this to avoid compilation errors. 
# See also https://github.com/keep-starknet-strange/garaga/issues/198 about using workspaces with garaga

```
{% endcode %}



### Supported Elliptic Curves

Garaga support operations on different elliptic curves. \
Curves are consistently identified throughout all Garaga code (Cairo/Python/Rust/Javascript) with identifiers (often referred as `CurveID` enums) :&#x20;

* 0 : BN254
* 1 : BLS12-381
* 2 : SECP256K1
* 3 : SECP256R1
* 4 : ED25519
* 5 : GRUMPKIN



