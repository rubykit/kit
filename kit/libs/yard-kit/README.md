# Yard Kit
Yard plugin for Kit gems.

Contains:
- some templates tweaks
- basic support for `kit-contracts`

## Todo

- Add real support for `kit-contracts`

## How to use it?

Add this gem to your `Gemfile`:
`gem 'yard-kit'`
Providing the `path` might be necessary if you are using it from within the `kit` repository.

To make YARD aware of this plugin, add the following to the `.yardopts` of your project:
`--plugin yard-kit`

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
