---
icon: python
---

# Python package

## Install the latest released version of the CLI

{% hint style="info" %}
PyPi link : [https://pypi.org/project/garaga/](https://pypi.org/project/garaga/)
{% endhint %}

The easiest way to install Garaga is via `pip`, which will fetch and install the pre-built binary wheels for your platform.

1. Open your terminal or command prompt.
2. (Optional) If you're using a [virtual environment (venv)](https://docs.python.org/3/library/venv.html), simply activate your venv.
3.  Run the following command to install latest release version:

    ```bash
    pip install garaga
    ```
4.  Once the package is successfully installed, the CLI will be accessible via the command line:

    ```bash
    garaga
    ```

{% hint style="info" %}
**Note that the current Garaga distribution does require Python 3.10.** One can use a Python Version Manager, such as [pyenv](https://github.com/pyenv/pyenv), to conveniently install the proper Python runtime.
{% endhint %}

{% hint style="info" %}
Please, ensure that the directory containing Python's executable files is included in your system's `PATH` environment variable. If you're using a venv, the necessary paths are automatically managed, so simply activate your venv before running the CLI.
{% endhint %}

{% hint style="info" %}
If your Python 3.10 installation is not supported by one of the pre-built binary wheels, `pip` will attempt to install Garaga from its source distribution. In that case, please make sure to have [Rust installed](https://www.rust-lang.org/tools/install) and available.
{% endhint %}

## Install a specific version or from a specific commit / from source

To install a specific version, use :

```bash
pip install --force-reinstall garaga==0.15.5

```

To install a version at specific commit, pick a commit hash from the [github history](https://github.com/keep-starknet-strange/garaga/commits/main/) and use :

```bash
pip install git+https://github.com/keep-starknet-strange/garaga.git@COMMIT_HASH
```

{% hint style="info" %}
Make sure the dependency on the Garaga Cairo library in `Scarb.toml` is at the same commit to ensure tooling are in sync.
{% endhint %}

## Installation troubleshooting

You might have some dependencies issues on Linux or MacOs related to some packages that uses C code.&#x20;

Refer to the installations notes of Starknet.py [https://starknetpy.readthedocs.io/en/latest/installation.html](https://starknetpy.readthedocs.io/en/latest/installation.html)  to fix those issues.&#x20;

