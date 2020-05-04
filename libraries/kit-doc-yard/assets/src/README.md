# Assets

> :warning: **All of this directory is a copy from [`ExDoc`](https://github.com/elixir-lang/ex_doc) (v0.21.3) and slighlty tweaked to make it work with `YardKit`.**

In this directory live all assets for `YardKit`. The built, ready-to-use
versions are cached in `assets/dist`.

## Installation

To work on these assets you need to install [Node.js] (version 10) and
[NPM] (version 5.6) first (maybe as superuser or administrator).

You will need to run `npm install` to resolve the packages before you can use `nmp run`.

## `npm run` scripts

The following scripts are available

### `build`

This will build a complete production bundle, including JavaScript and CSS, in `assets/dist`.

### `lint`

Lint all JavaScript files using [ESLint].

### `test`

Run all the available JavaScript tests using [Karma].

## Webpack

Internally we use [Webpack]. We also use [Less] for organizing stylesheets.

[ExDoc]: https://github.com/elixir-lang/ex_doc
[Node.js]: https://nodejs.org/
[NPM]: https://www.npmjs.com/
[ESLint]: https://eslint.org/
[Karma]: https://karma-runner.github.io/
[Webpack]: https://webpack.js.org/
[Less]: http://lesscss.org/
