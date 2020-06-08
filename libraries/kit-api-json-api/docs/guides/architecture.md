# Kit::Api architecture

TODO: explain the various objects of `Kit::Api` & how they fit / interact with each other.

## Steps

- Parsing a request: transform the data from a `JSON:API HTTP request` or `GraphQL request` to a `Request` object (high level representation of the requested data).
- Generate a `Query` from that `Request`.
- Validate the `Query`.
- Resolve the `Query`: load the `Resources` data using `pagination` (subset), `sort` (ordering), `filtering` (conditions). Every `Resource` can be loaded in isolation, regardless of the level of nesting.
- Serialize the `Query` according to the used specs (generate `links`, apply `sparse fieldsets`, etc)

## Resolvers

Load data from your persistence layer or external services as Resources.

TODO: add explaination on JOIN / PRELOAD impact for distributed systems, Presto like solutions, etc.

## Query

```
query = Query[
  data: [Post1, Post2, Post3],
  relationships: [
    { # Relationships for Post1
      comments: {
        data: [Comment1A, Comment2B],
        relationships: [...], 
    },
    { # Relationships for Post2
      comments: [Comment2A],
      relationships: [...],
    },
  ],
  included: {
    comments: {
      data: [...],
    },
  },
}]

# Access to relationship of Post1 (might trigger a call since we traverse trough Post1)
query.data[1].comments
# Access to the ordered collection of Post1:
query.relationships[1].comments.data
```
