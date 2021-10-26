<!--pp {} -->
<img align="left" width="50" height="90" src="https://raw.githubusercontent.com/rubykit/kit/main/docs/assets/images/rubykit-framework-logo.svg">
<!-- pp-->

[Kit::RspecFormatter]: https://github.com/rubykit/kit/tree/main/libraries/kit-rspec_formatter

# Kit::RspecFormatter

[Kit::RspecFormatter] is a simple [Rspec custom formatter](https://relishapp.com/rspec/rspec-core/docs/formatters/custom-formatters)

## Usage

1) Add `kit-rspec_formatter` to your Gemfile
2) Add the following to your `spec_helper.rb`:
```
require 'kit/rspec_formatter'

RSpec.configure do |config|
  config.formatter = Kit::RspecFormatter::Formatter
end
```

## Copyright & License

Copyright (c) 2021, Nathan Appere.

[Kit::RspecFormatter] is licensed under [MIT License](MIT_LICENSE.md).
