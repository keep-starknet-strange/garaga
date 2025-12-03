---
icon: sparkles
---

# Cairo Library

The Garaga Cairo library is available on the [scarbs.xyz registry](https://scarbs.xyz/packages/garaga), the official package registry for Cairo/Scarb projects.

## Quick Install

The recommended way to add Garaga to your Cairo project:

```bash
scarb add garaga
```

This will add the latest version to your `Scarb.toml`.

## Manual Installation

Alternatively, add Garaga directly to your `Scarb.toml`:

```toml
[dependencies]
garaga = "1.0.1"

[cairo]
sierra-replace-ids = false  # Required for Garaga
```

{% hint style="warning" %}
**Important:** The `sierra-replace-ids = false` setting is required for Garaga to compile correctly.
{% endhint %}

## Installing a Specific Version

To install a specific version:

```bash
scarb add garaga@1.0.1
```

Or in `Scarb.toml`:

```toml
[dependencies]
garaga = "=1.0.1"  # Exact version
```

## Installing from Git

If you need an unreleased version or a specific commit:

```toml
[dependencies]
garaga = { git = "https://github.com/keep-starknet-strange/garaga.git", tag = "v1.0.1" }
```

Or from a specific branch/commit:

```toml
[dependencies]
garaga = { git = "https://github.com/keep-starknet-strange/garaga.git", branch = "main" }
```

{% hint style="info" %}
For more information on managing dependencies with Scarb, see the [Scarb documentation](https://docs.swmansion.com/scarb/docs/guides/dependencies.html).
{% endhint %}

## Version Compatibility

{% hint style="warning" %}
**Version Matching:** When using Garaga SDKs (Python, Rust, npm) to generate calldata, ensure the Cairo library version matches the SDK version. Mismatched versions may produce incompatible calldata.

For example, if using `pip install garaga==1.0.1`, use `garaga = "1.0.1"` in your `Scarb.toml`.
{% endhint %}

## Usage

After installation, you can import Garaga modules:

```cairo
use garaga::definitions::{G1Point, u384};
use garaga::ec_ops::msm_g1;
use garaga::signatures::ecdsa::{ECDSASignatureWithHint, is_valid_ecdsa_signature_assuming_hash};
```

See [Using Garaga Libraries](../using-garaga-libraries-in-your-cairo-project/) for detailed usage documentation.

## Registry Links

* **Package Page:** [scarbs.xyz/packages/garaga](https://scarbs.xyz/packages/garaga)
* **Source Code:** [github.com/keep-starknet-strange/garaga](https://github.com/keep-starknet-strange/garaga)
