# Kit::Doc

`Kit::Doc` is a [Yard](https://github.com/lsegal/yard) plugin that generates [ExDoc](https://github.com/elixir-lang/ex_doc) look-alike documentation. We generate compatible html to be able to reuse their styling and JS logic.

## Todo

- Add real support for `kit-contracts`. Currently they are ignored as to not mess up the documentation.

## Usage

Add this gem to your `Gemfile`:
`gem 'kit-doc'`
Providing the `path` might be necessary if you are using it from within the `kit` repository.

To make YARD aware of this plugin, add the following to the `.yardopts` of your project:
`--plugin kit-doc`

## License

YardKit is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[ExDoc](https://github.com/elixir-lang/ex_doc) source code is released under Apache 2 License. This gem reuse their content generation logic, which includes different licenses based on projects used to help render HTML, including CSS, JS, and other assets.

Check the [LICENSE](./LICENSE) file for more information.