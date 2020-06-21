# Absolute pagination

With this strategy, the `subset id` will always returns the **same** `subset` (minus elements that have been deleted since that access).

The `subset id` needs to contain data that allows to identify the subset in an absolute way: often, a unique proprety of the `first element` and `last element` of the `subset`.

To avoid collisions between `subsets`, the last (or least important) `ordering parameter` used always need to be **unique**.

### Examples:

| Ordering | Status | Note |
|-------------------------------------------|-------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `[[:uid, :asc], [:created_at, :desc]]` | **Valid** | But `created_at` will never be used since `uid` is already unique |
| `[[:created_at, :desc]]` | **Invalid** | You might have `elements` of the `sets` that have similar creation timestamps. This can lead to collisions between `subsets`: the same element can be returned in different pages |
| ``[[[:created_at, :desc], [:uid, :asc]]`` | **Valid** | Even if you don't care about `:uid` in itself, adding it allows to uniquely identify elements of the set. |        