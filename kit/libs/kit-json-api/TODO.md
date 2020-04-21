# TODO

* [x] Add handling of singular for top level && relationships (behaviour in `data`)
* [x] Can there be collisions for relationship linkage when object is loaded N times? Probably only on limit, but this need to be accounted for.
* [ ] Reassess the previous question. I now don't think this can happen.

* [ ] Add relationships links (need to re-identify the collection?)
* [ ] Add paginations to links
* [ ] Add filters to links

* One issue currently is: how do you prevent collision in relationship links when the same relation can be accessed through different path, with different set size? It seems we need a way to identify a 2 level tupple in a unique way, but the naming of a relationship != to the object types.

* Maybe there should be NO FILTERING for relationships (reserved for attributes). Instead one need to use the relationship link. The downside is: no possible multiple selection on foreign key, like `/books?filters[authors]=1,2`

* Is there ANY expectation from something like Ember Data to be able to identify a nested collection VS top level? Sideloading might be ONLY for the store, and not a valid way to create app level `collections`

* FOR A STORE: relationship BY FEATURE, not TYPE OF OBJECT! Post > LatestComments VS Post > Comments

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