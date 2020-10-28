# Rubocop setup

How to setup `Rubocop` in a domain or library.

## Shared logic

General project rules are setup alphabetically in `$kit/.rubocop_shared.yml`

This is the file sub-directories `$kit/.rubocop.yml` should `inherit_from`.

Note: inheriting from `$kit/.rubocop.yml`.

## Implicit behaviours

**⚠️ Warning**: when using rubocop in a sub-directory, it implicitely inherits the `Exclude` hash of any `.rubocop.yml` files in parent folders.

The behaviour can be disabled by using `--ignore-parent-exclusion`.

## Running rubocop

`bundle exec rubocop`

## Refs

- [Default rubocop.yml](https://github.com/rubocop-hq/rubocop/blob/master/config/default.yml)
- [Rubocop Configuration](https://docs.rubocop.org/rubocop/configuration.html)
- [Command line flags](https://docs.rubocop.org/rubocop/0.89/usage/basic_usage.html#command-line-flags)