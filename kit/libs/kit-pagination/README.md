# Kit::Pagination

Allows to paginate `sets` with different strategies.

## What is Pagination ?
For a `set` that contains N `elements`, pagination is way to obtain `subsets` of this `set` (often with `ordering` constraints). This `subset` can be referred to as a `page`".

## Page ID
In order to identify that `subset`, you will need a `subset identifier` (or `subset id`, `page id`).

This `page id`  contains the data necessary to obtain a `subset`.

|  | **Transparent** | **Opaque** |
|-----------------|-------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Example | `page=2` | `page=LKJlhJ_h2` |
| Pagination data | Visible to the pagination user  | Not visible to the pagination user  |
| Access | Sequential or not | Sequential only |
| Used when | * The pagination data is simple * Non sequential access is needed | * The pagination data is complex * non sequential access is not needed Here the client receives an opaque chunk of data, the `cursor`, that is sent back to get the next or previous page. |

## Absolute pagination

With this strategy, the `subset id` will always returns the **same** `subset` (minus elements that have been deleted since that access).

The `subset id` needs to contain data that allows to identify the subset in an absolute way: often, a unique proprety of the `first element` and `last element` of the `subset`.

To avoid collisions between `subsets`, the last (or least important) `ordering parameter` used always need to be **unique**.

### Examples:

| Ordering | Status | Note |
|-------------------------------------------|-------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `[[:uid, :asc], [:created_at, :desc]]` | **Valid** | But `created_at` will never be used since `uid` is already unique |
| `[[:created_at, :desc]]` | **Invalid** | You might have `elements` of the `sets` that have similar creation timestamps. This can lead to collisions between `subsets`: the same element can be returned in different pages |
| ``[[[:created_at, :desc], [:uid, :asc]]`` | **Valid** | Even if you don't care about `:uid` in itself, adding it allows to uniquely identify elements of the set. |                                                                       |


## Usage

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'kit_pagination'
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
