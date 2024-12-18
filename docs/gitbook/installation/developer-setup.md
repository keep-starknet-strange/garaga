---
icon: wrench
---

# Developer setup

To work with Garaga, you need the following dependencies :&#x20;

* Python 3.10.  The command `python3.10` should be available and working in your terminal.&#x20;
* [Scarb](https://docs.swmansion.com/scarb/download.html) v2.9.1.&#x20;
* [Rust](https://www.rust-lang.org/tools/install)

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

Pay attention to any message indicating failure. Contact us on Garaga telegram if you have any trouble at this point.&#x20;

If everything succeeded, you're good to go!

{% hint style="info" %}
Make sure to activate the virtual environment created with this setup, using `source/venv/bin/activate`&#x20;
{% endhint %}
