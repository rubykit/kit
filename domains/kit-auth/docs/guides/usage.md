# Usage

## Gem installation

Add this line to your application's Gemfile:

```ruby
gem 'kit-auth'
```

And run:
```sh
$ bundle install
```

## Tasks

### Documentation

Run:
```sh
$ bundle exec rake documentation:generate
```

### Router aliases

Run:
```sh
$ bundle exec router:generate_graph
```

## Databases setup

Note: `schema.rb` is generated in the dummy app, as it does not belong to the engine per-se.

### Development

```sh
RAILS_ENV=development bundle exec rails db:create:primary_ops
RAILS_ENV=development bundle exec rails db:migrate:primary_ops
RAILS_ENV=development bundle exec rails db:seed:oauth_applications
```

### Testing
```sh
RAILS_ENV=test bundle exec rails db:create:primary_ops
RAILS_ENV=test bundle exec rails db:migrate:primary_ops
RAILS_ENV=test bundle exec rails db:seed:oauth_applications
```
