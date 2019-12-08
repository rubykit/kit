# Kit::JsonApi

`Kit::JsonApi` helps you to implement a server side API conforming to [version 1.1](https://jsonapi.org/format/1.1/) of the JSON:API spec.

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

## Steps

- Parsing a JSON:API request: transform the data inside an `HTTP request` to a `Kit::JsonApi::Types::Query` (high level representation of the requested data).
- Validating the `Kit::JsonApi::Types::Query`
- Loading the `Resources` data using `pagination` (subset), `sort` (ordering), `filtering` (conditions). Every `Resource` can be loaded in isolation, regardless of the level of nesting.
- Applying `Sparse fieldsets`
- Serialization

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
