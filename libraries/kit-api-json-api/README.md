# Kit::Api::JsonApi

`Kit::Api::JsonApi` helps you to implement a server side API conforming to [version 1.1](https://jsonapi.org/format/1.1/) of the JSON:API spec.

The goal of this gems are to:
- parse & verify JSON:API query strings
- describe endpoints that can serve [JSON:API Documents](http://jsonapi.org/format)
- describe Resources that can be exposed as [JSON:API Documents](http://jsonapi.org/format)
- transform data from your persistence layer to resources

## JSON:API Support

Current status:

- [ ] [JSONAPI Document](http://jsonapi.org/format/#document-top-level) encoding
- [ ] [Links](http://jsonapi.org/format/#document-links)
- [ ] [Sparse fieldsets](https://jsonapi.org/format/#fetching-sparse-fieldsets) Note that fieldsets are per type and not per relationship.
- [ ] [Sorting](https://jsonapi.org/format/#fetching-sorting)
- [ ] [Pagination](https://jsonapi.org/format/#fetching-pagination)
- [ ] Relationships: links (including nested pagination)
- [ ] Relationships: [includes](https://jsonapi.org/format/#fetching-includes)
- [ ] Relationships: [compound documents](http://jsonapi.org/format/#document-compound-documents) (sideloading)
- [ ] Top level meta data
- [ ] Errors

Not supported:
- Polymorphic relationships. Nothing in the spec prevents them, but I have yet to find a good usecase.

## Steps

- Parsing a JSON:API request: transform the data inside an `HTTP request` to a `Request` (high level representation of the requested data).
- Generate a `Query` from that `Request`
- Validating the `Query`
- Resolving the `Query`: loading the `Resources` data using `pagination` (subset), `sort` (ordering), `filtering` (conditions). Every `Resource` can be loaded in isolation, regardless of the level of nesting.
- Serialize the `Query`: generate `links`, apply `sparse fieldsets`

## Client

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

## References

- [jsonapi-grader](https://github.com/beauby/jsonapi-grader)
- [fantasy-dabatase](https://github.com/endpoints/fantasy-database)
- [endpoints-example](https://github.com/endpoints/endpoints-example)
- [Elixir implementation](https://github.com/jeregrine/jsonapi)

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
