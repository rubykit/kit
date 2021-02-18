# Testing

## Setting up the database

```
RAILS_ENV=test bundle exec rails db:create:primary_ops
RAILS_ENV=test bundle exec rails db:migrate:primary_ops
RAILS_ENV=test bundle exec rake db:seed:fantasy_data
```

## Running the tests

```
ENV=test bundle exec rspec
```