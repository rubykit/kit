# TODO

* A `Resource` class definition
  * Works in **isolation**
  * Receives the `conditions` (`filtering`) / `ordering` (`sort`) and `pagination data` (should this purely be size based? other data are technically filtering)
  * Nesting only means we get extra `filters` (ex: for users.comments, where comments.user_id=N, or "in set" )
  * Knows how to retrieve the data
  * Knows how to generate links

* We get a "request" that is validated against the Resources. This creates the real "query".