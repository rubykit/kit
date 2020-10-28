# Usage

## Gem installation

Add this line to your application's Gemfile:

```ruby
gem 'kit-auth'
```

And then execute:
```sh
$ bundle install
```

## Databases setup

Note: `schema.rb` is generated in the dummy app, as it does not belong to the engine per-se.

### Development

```sh
RAILS_ENV=development bundle exec rails db:create:primary_ops
RAILS_ENV=development bundle exec rails db:migrate:primary_ops
```

### Testing
```sh
RAILS_ENV=test rails db:create:primary_ops
RAILS_ENV=test rails db:migrate:primary_ops
```
