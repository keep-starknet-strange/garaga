---
icon: wrench
---

# Developer setup & guides

### Installation

To work with Garaga, you need the following dependencies :

* Python 3.10. The command `python3.10` should be available and working in your terminal.
* [Scarb](https://docs.swmansion.com/scarb/download.html) with the version specified in [https://github.com/keep-starknet-strange/garaga/blob/main/src/.tool-versions](https://github.com/keep-starknet-strange/garaga/blob/main/src/.tool-versions/README.md)
* [Rust](https://www.rust-lang.org/tools/install)

Simply clone the [repository](https://github.com/keep-starknet-strange/garaga) :

Using git:

```bash
git clone https://github.com/keep-starknet-strange/garaga.git
```

Using [github cli ](https://cli.github.com/):

```bash
gh repo clone keep-starknet-strange/garaga
```

After that, go into the root of the directory and run the command :

```bash
make setup
```

Pay attention to any message indicating failure. Contact us on Garaga telegram if you have any trouble at this point.

If everything succeeded, you're good to go!

{% hint style="info" %}
Make sure to activate the virtual environment created with this setup, using `source/venv/bin/activate`
{% endhint %}

###
