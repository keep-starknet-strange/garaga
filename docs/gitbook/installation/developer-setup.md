---
icon: wrench
---

# Developer setup

To work with Garaga, you need the following dependencies :&#x20;

* [Rust](https://www.rust-lang.org/tools/install)
* [Scarb](https://docs.swmansion.com/scarb/download.html) v2.14.0

Python 3.10-3.12 is used for development but does **not** need to be installed manually — `make setup` will auto-install it via [uv](https://docs.astral.sh/uv/) if it's not already available.

Simply clone the [repository](https://github.com/keep-starknet-strange/garaga) :

Using git:

```bash
git clone https://github.com/keep-starknet-strange/garaga.git
```

Using [github cli ](https://cli.github.com/) :

```bash
gh repo clone keep-starknet-strange/garaga
```

After that, go into the root of the directory and run the command :&#x20;

```bash
make setup
```

This will automatically install [uv](https://docs.astral.sh/uv/) and Python 3.12 if needed, create a virtual environment, install all dependencies, and build the Rust extension. The setup is idempotent — running it again updates dependencies without recreating the venv.

Pay attention to any message indicating failure. Contact us on Garaga telegram if you have any trouble at this point.&#x20;

If everything succeeded, you're good to go!

{% hint style="info" %}
Make sure to activate the virtual environment created with this setup, using `source venv/bin/activate`
{% endhint %}
