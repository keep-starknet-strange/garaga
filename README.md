<div align="center">
  <h1>Garaga</h1>
  <img src="docs/images/logo.png" height="200">
  <br />
  <a href="https://github.com/keep-starknet-strange/garaga/issues/new?assignees=&labels=bug&template=01_BUG_REPORT.md&title=bug%3A+">Report a Bug</a>
  -
  <a href="https://github.com/keep-starknet-strange/garaga/issues/new?assignees=&labels=enhancement&template=02_FEATURE_REQUEST.md&title=feat%3A+">Request a Feature</a>
  -
  <a href="https://github.com/keep-starknet-strange/garaga/discussions">Ask a Question</a>
</div>

<div align="center">
<br />

[![GitHub Workflow Status](https://github.com/keep-starknet-strange/garaga/actions/workflows/test.yml/badge.svg)](https://github.com/keep-starknet-strange/garaga/actions/workflows/test.yml)
[![Project license](https://img.shields.io/github/license/keep-starknet-strange/garaga.svg?style=flat-square)](LICENSE)
[![Pull Requests welcome](https://img.shields.io/badge/PRs-welcome-ff69b4.svg?style=flat-square)](https://github.com/keep-starknet-strange/garaga/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22)

</div>

<details open="open">
<summary>Table of Contents</summary>

- [About](#about)
- [Architecture overview](#architecture-overview)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
    - [Cairo](#cairo)
  - [Usage](#usage)
    - [Create a virtual environment and install the dependencies](#create-a-virtual-environment-and-install-the-dependencies)
    - [Compile cairo files](#compile-cairo-files)
    - [Profiling](#profiling)
- [Roadmap](#roadmap)
- [Support](#support)
- [Project assistance](#project-assistance)
- [Contributing](#contributing)
- [Authors \& contributors](#authors--contributors)
- [Security](#security)
- [License](#license)
- [Acknowledgements](#acknowledgements)
- [Resources](#resources)
- [Contributors ✨](#contributors-)

</details>

## About

> Efficient pairing library using polynomial representation of field elements, written in Cairo 🐺.

Garaga can enable efficient pairing operations in StarkNet, by using polynomial representation of field elements. This is a work in progress, and is not yet ready for production use.

Here are some interesting use cases enabled by Garaga:
- SNARKs on StarkNet: would enable privacy-preserving computations on StarkNet.
- KZG cryptographic commitment scheme.
- Identity-based encryption schemes.
- Attribute-based encryption schemes.
- BLS (Boneh–Lynn–Shacham) Digital Signature scheme. 

We are exploring many optimizations techniques. For example, we are currently working on a new technique to reduce the number of constraints in the pairing computation. This technique is based on the idea of using a polynomial representation of field elements.
## Architecture overview

[![Architecture overview](docs/images/garaga-architecture-overview.png)](docs/images/garaga-architecture-overview.png)

## Getting Started

### Prerequisites

#### Cairo
- [cairo-lang](https://www.cairo-lang.org/docs/installation.html)
- [Python 3.9](https://www.python.org/downloads/)
  
Specifically for profiling and testing, the following tools dependencies are required:
- [Go](https://golang.org/doc/install)
- [pprof](https://github.com/google/pprof)
- [graphviz](https://graphviz.org/download/) 

### Usage


#### Create a virtual environment and install the dependencies

```bash
make setup
```

#### Compile cairo files

```bash
make build
```

#### Run and profile programs in tests/cairo_programs (interactive script) 

```bash
make run-profile
```
#### Compile Go parsing tool for tests

```bash 
make go 
```
#### Run all or specific protostar tests
```bash
protostar test --max-steps 10000000
protostar test --max-steps 10000000 tests/protostar_tests/test_e2.cairo
protostar test --max-steps 10000000 tests/protostar_tests/test_pair.cairo::test_final_exp
```
## Roadmap

See the [open issues](https://github.com/keep-starknet-strange/garaga/issues) for
a list of proposed features (and known issues).

- [Top Feature Requests](https://github.com/keep-starknet-strange/garaga/issues?q=label%3Aenhancement+is%3Aopen+sort%3Areactions-%2B1-desc)
  (Add your votes using the 👍 reaction)
- [Top Bugs](https://github.com/keep-starknet-strange/garaga/issues?q=is%3Aissue+is%3Aopen+label%3Abug+sort%3Areactions-%2B1-desc)
  (Add your votes using the 👍 reaction)
- [Newest Bugs](https://github.com/keep-starknet-strange/garaga/issues?q=is%3Aopen+is%3Aissue+label%3Abug)

## Support

Reach out to the maintainer at one of the following places:

- [GitHub Discussions](https://github.com/keep-starknet-strange/garaga/discussions)
- Contact options listed on
  [this GitHub profile](https://github.com/starknet-exploration)
- [Telegram](https://t.me/GaragaPairingCairo)

## Project assistance

If you want to say **thank you** or/and support active development of Garaga:

- Add a [GitHub Star](https://github.com/keep-starknet-strange/garaga) to the
  project.
- Tweet about the Garaga.
- Write interesting articles about the project on [Dev.to](https://dev.to/),
  [Medium](https://medium.com/) or your personal blog.

Together, we can make Garaga **better**!

## Contributing

First off, thanks for taking the time to contribute! Contributions are what make
the open-source community such an amazing place to learn, inspire, and create.
Any contributions you make will benefit everybody else and are **greatly
appreciated**.

Please read [our contribution guidelines](docs/CONTRIBUTING.md), and thank you
for being involved!

## Authors & contributors

For a full list of all authors and contributors, see
[the contributors page](https://github.com/keep-starknet-strange/garaga/contributors).

## Security

Garaga follows good practices of security, but 100% security cannot be assured.
Garaga is provided **"as is"** without any **warranty**. Use at your own risk.

_For more information and to report security issues, please refer to our
[security documentation](docs/SECURITY.md)._

## License

This project is licensed under the **MIT license**.

See [LICENSE](LICENSE) for more information.

## Acknowledgements

- Huge props to [tekkac](https://github.com/tekkac) and [feltroidprime](https://github.com/feltroidprime) for their initial work on provable pairing-based cryptography in StarkNet.
- Credits to [Nethermind](https://github.com/NethermindEth/) for their [initial work on optimized modular arithmetic](https://github.com/NethermindEth/research-basic-Cairo-operations-big-integers/tree/main/lib).
- [Herodotus](https://www.herodotus.dev/) for supporting this project.
- [Gnark project](https://github.com/ConsenSys/gnark-crypto) and team, especially [yelhousni](https://github.com/yelhousni) for his amazing knowledge and support.
- [OnlyDust](https://www.onlydust.xyz/) and [Starkware](https://starkware.co/). 
## Resources

Here are some interesting resources about pairing-based cryptography:

> **Note:** This list is not exhaustive, and is not intended to be.

- Document A :: [Pairing for beginners](https://static1.squarespace.com/static/5fdbb09f31d71c1227082339/t/5ff394720493bd28278889c6/1609798774687/PairingsForBeginners.pdf) : A beginner-friendly overall introduction of the concept and techniques, including Towered extension fields in section 7.3. (2012)  
- Document B :: [Efficient Hardware Implementation of IFp-Arithmetic for Pairing-Friendly Curves](https://ieeexplore.ieee.org/abstract/document/5740859) : Fast Fp modular multiplication using polynomial representation of field elements. Currently being implemented. (2012)  
- Document C :: [High-Speed Software Implementation of the Optimal Ate Pairing over Barreto–Naehrig Curves](https://eprint.iacr.org/2010/354.pdf) Useful, relatively effective ready-to-use formulas including for Fp, Fp12 arithmetics. Should be composable with Document B.  
- Document D :: [Efficient Multiplication over Extension Fields](https://www.emse.fr/~nadia.el-mrabet/Article/WAIFI2012.pdf) Generalized Arithmetic on any extension field using polynomial representation of field elements. This work could enable polynomial representation of elements of finite field of any prime order, and thus very efficient pairing for any BN curve, including alt_bn128. 
- Document E :: [Accelerated tower arithmetic](https://hal.archives-ouvertes.fr/hal-01788403/file/tower.pdf)  Close to state-of-the art solution for Fp12 arithmetics. Similar to Document D but harder. (2019)  


## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/feltroidprime"><img src="https://avatars.githubusercontent.com/u/96737978?v=4?s=100" width="100px;" alt="Feltroid Prime"/><br /><sub><b>Feltroid Prime</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/garaga/commits?author=feltroidprime" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/abdelhamidbakhta"><img src="https://avatars.githubusercontent.com/u/45264458?v=4?s=100" width="100px;" alt="Abdel @ StarkWare "/><br /><sub><b>Abdel @ StarkWare </b></sub></a><br /><a href="https://github.com/keep-starknet-strange/garaga/commits?author=abdelhamidbakhta" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/tekkac"><img src="https://avatars.githubusercontent.com/u/98529704?v=4?s=100" width="100px;" alt="Tarik K."/><br /><sub><b>Tarik K.</b></sub></a><br /><a href="https://github.com/keep-starknet-strange/garaga/commits?author=tekkac" title="Code">💻</a></td>
    </tr>
  </tbody>
  <tfoot>
    <tr>
      <td align="center" size="13px" colspan="7">
        <img src="https://raw.githubusercontent.com/all-contributors/all-contributors-cli/1b8533af435da9854653492b1327a23a4dbd0a10/assets/logo-small.svg">
          <a href="https://all-contributors.js.org/docs/en/bot/usage">Add your contributions</a>
        </img>
      </td>
    </tr>
  </tfoot>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
