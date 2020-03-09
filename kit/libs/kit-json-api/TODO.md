# TODO

* [x] Add handling of singular for top level && relationships (behaviour in `data`)
* [ ] Add relationships links

* [ ] Add paginations to links
* [ ] Add filters to links

---

* Add pagination logic && figure out how it should work per resource
  > IN:  pagination data is extracted from the payload and added to the query
  > OUT: link generation from content

* Links:
  ** The ResourceObj contains the logic to generate all types of link for the resource
  ** Self: One level
  ** Relationship: Does it need to be defined on every relationship ? Or just external modifiers ? (Would they live in the query ?)

  ** Collection:
    - Top level: https://jsonapi.org/examples/#pagination
    - Relationship: https://jsonapi.org/recommendations/#including-links

* App setup:
  * Add spec models
  * Figure out how to make migrations work in dummy app?

* RESEARCH: write / update operations

* RESEARCH: what is a correct way to describe including relationship `full data` VS `only id` VS `only links` ?

* A `Resource` class definition
  * Works in **isolation**
  * Receives the `conditions` (`filtering`) / `ordering` (`sort`) and `pagination data` (should this purely be size based? other data are technically filtering)
  * Nesting only means we get extra `filters` (ex: for users.comments, where comments.user_id=N, or "in set" )
  * Knows how to retrieve the data
  * Knows how to generate links

* We get a "request" that is validated against the Resources. This creates the real "query".

* RESEARCH: how to load paginated subsets
  * https://stackoverflow.com/questions/2129693/using-limit-within-group-by-to-get-n-results-per-group
  * http://sqlfiddle.com/#!17/378a3/6

```sql
SELECT *
FROM (
    SELECT *, RANK() OVER (PARTITION BY user_id ORDER BY created_at ASC) AS rank
    FROM  comments
    WHERE user_id IN (1, 3) 
) AS data
WHERE data.rank <= 2
```