---
icon: gear
---

# Installation

Garaga is available in multiple formats for different use cases:

| Package | Use Case | Install Command |
|---------|----------|-----------------|
| [**Python package**](python-package.md) | CLI for generating verifiers, deployment, calldata generation | `pip install garaga` |
| [**Cairo Library**](cairo-library.md) | Use Garaga's Cairo primitives in your smart contracts | `scarb add garaga` |
| [**Rust Crate**](rust-crate.md) | Rust applications, calldata generation | `cargo add garaga_rs` |
| [**npm package**](npm-package.md) | Browser dApps, frontend integration | `npm install garaga` |

## Quick Start

{% tabs %}
{% tab title="Python" %}
```bash
pip install garaga
garaga --help
```
{% endtab %}

{% tab title="Cairo" %}
```bash
scarb add garaga
```
Or in `Scarb.toml`:
```toml
[dependencies]
garaga = "1.0.1"
```
{% endtab %}

{% tab title="Rust" %}
```toml
[dependencies]
garaga_rs = { git = "https://github.com/keep-starknet-strange/garaga.git", tag = "v1.0.1" }
```
{% endtab %}

{% tab title="npm" %}
```bash
npm install garaga
```
{% endtab %}
{% endtabs %}

## Version Compatibility

All Garaga packages are released together with matching version numbers. When using multiple packages, ensure they all use the same version to guarantee compatibility.

For example, when using version 1.0.1:
- Python: `pip install garaga==1.0.1`
- Cairo: `garaga = "1.0.1"` in Scarb.toml
- Rust: `tag = "v1.0.1"` in Cargo.toml
- npm: `npm install garaga@1.0.1`

## Developer Setup

For contributing to Garaga or advanced development workflows, see the [Developer Setup & Guides](../developer-setup-and-guides/README.md).
