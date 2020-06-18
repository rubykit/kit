# JSON:API vs GraphQL

While `JSON:API` & `GraphQL` attempt to solve the same categories of problems, they take different approaches.

## JSON:API

The spec is mostly about defining operations & the response format.
Because the operations are CRUD based, you are always acting on `Resources`.

A `search` operation could be modeled as `POST /searches?author=Leckie`.

| Property | Quick overview |
| -------- | -------- |
| `A` Query interface | URL based. The API will need to provide N endpoints that describe the top level resources being acted on. |
| `B` Query format | REST based CRUD operations. Top level resource verb + top level resource url. Pagination / filters / sorting are specified through query parameters. |
| `C` API's resources standardization | Resources types are identified but not checked on. [Schema Support #1281](https://github.com/json-api/json-api/issues/1281) |
| `D` Response format | This is what the spec is mostly about.<br> The response format is quite complete: relationship VS attributes, resource de-duplication, linkage options... |

## GraphQL

`GraphQL` scope is larger, so it does more things.

| Property | Quick overview |
| -------- | -------- |
| `A` Query interface | Database like. You can expose an entry point through various protocols to receive a GraphQL query. |
| `B` Query format | GraphQL is its own [query language](https://spec.graphql.org/June2018/#sec-Language.Operations). It differentiates between read-only ("query") operations and write ("mutable") operations. |
| `C` API's resources standardization | Through schemas of the [type system](https://spec.graphql.org/June2018/#sec-Schema). |
| `D` Response format | JSON based. Allows duplication of resources in the payload (this makes returning collections easier.) |

Various:
- GraphQL provides "subscription" operations. They allow the API server to push data to registered clients.
