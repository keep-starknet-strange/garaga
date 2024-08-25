---
icon: snake
---

# Python package

The easiest way to install Garaga is via `pip`, which will fetch and install the pre-built binary wheels for your platform.

1. Open your terminal or command prompt.
2. (Optional) If you're using a [virtual environment (venv)](https://docs.python.org/3/library/venv.html),  simply activate your venv.
3.  Run the following command:

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
If your Python 3.10 installation is not supported by one of the pre-built binary wheels,  `pip` will attempt to install Garaga from its source distribution. In that case, please make sure to have [Rust installed](https://www.rust-lang.org/tools/install) and available.
{% endhint %}
