# JsonApi support

`Kit::Api::JsonApi` helps you to implement a server side API conforming to [JSON:API v1.1](https://jsonapi.org/format/1.1/) spec.

The goals of this gems are to:
- describe endpoints that can serve & modify [JSON:API Documents](http://jsonapi.org/format)
- parse & verify `JSON:API` query strings requests
- describe Resources that can be exposed as [JSON:API Documents](http://jsonapi.org/format)

## Support

Current status:

- [x] [JSONAPI Document](http://jsonapi.org/format/#document-top-level) encoding
- [x] [Links](http://jsonapi.org/format/#document-links)
- [x] [Sparse fieldsets](https://jsonapi.org/format/#fetching-sparse-fieldsets) Note that fieldsets are per type and not per relationship.
- [x] [Sorting](https://jsonapi.org/format/#fetching-sorting)
- [x] [Pagination](https://jsonapi.org/format/#fetching-pagination)
- [x] Relationships: links (including nested pagination)
- [x] Relationships: [includes](https://jsonapi.org/format/#fetching-includes)
- [x] Relationships: [compound documents](http://jsonapi.org/format/#document-compound-documents) (sideloading)
- [x] Top level resources queries
- [ ] Top level relationships queries
- [ ] Top level meta data
- [ ] Errors

Not supported:
- Polymorphic relationships. Nothing in the spec prevents them, but this seems mostly like an anti-pattern: trying to hide a join model works only if there are no attributes in use on that model, appart from foreign keys. This is often unlikely.

## References

- [jsonapi-grader](https://github.com/beauby/jsonapi-grader)
- [fantasy-dabatase](https://github.com/endpoints/fantasy-database)
- [endpoints-example](https://github.com/endpoints/endpoints-example)
- [Elixir implementation](https://github.com/jeregrine/jsonapi)
