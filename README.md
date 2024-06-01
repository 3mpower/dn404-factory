# DN404 Factory 🥜

[![CI][ci-shield]][ci-url]

DN404 Factory is a set of contracts built for the DN404 implementation that enables anyone to deploy their own DN404 contracts.

## Contracts

The Solidity smart contracts are located in the `src` directory.

```ml
src
├─ DN404Factory — "Factory contract for DN404"
├─ DN404Cloneable — "Cloneable contract for DN404"
```

## Contributing

Feel free to make a pull request.

## Safety

This is **experimental software** and is provided on an "as is" and "as available" basis.

We **do not give any warranties** and **will not be liable for any loss** incurred through any use of this codebase.

While DN404Factory and DN404Cloneable has been heavily tested, there may be parts that exhibit unexpected emergent behavior when used with other code, or break in future Solidity versions.

Please always include your own thorough tests when using DN404Factory and DN404Cloneable to make sure it works correctly with your code.

Please call any required internal initialization methods accordingly.

## Acknowledgements

This repository is inspired by various sources:

- [DN404](https://github.com/vectorized/dn404)
- [Solady](https://github.com/vectorized/solady)

[npm-shield]: https://img.shields.io/npm/v/dn404.svg
[npm-url]: https://www.npmjs.com/package/dn404
[ci-shield]: https://img.shields.io/github/actions/workflow/status/vectorized/dn404/ci.yml?branch=main&label=build
[ci-url]: https://github.com/vectorized/dn404/actions/workflows/ci.yml
