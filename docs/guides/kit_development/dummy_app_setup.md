# Dummy-app setup

A quick summary of how to setup `Kit::DummyAppContainer` in a domain or library.

To learn more about dummy apps, have a look at Rails's guide [Testing an engine](https://guides.rubyonrails.org/engines.html#testing-an-engine).

## Files to import

Here is a list of files that need to be changed in order to use `kit-app-dummy-container`.

- `Rakefile`
- `bin/rails`
- `kit_runtime_config.rb`
- `spec/rails_helper.rb`

## `kit_runtime_config.rb`

This file contains the setup needed by `kit-app-dummy-container` to load correctly.

The goal is to be able to have very simple dummy app without all the usual boilerplate.

**⚠️ Warning**: it is NOT currently used by the regular `kit-app_container`.



