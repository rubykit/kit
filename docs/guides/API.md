
# JSON API
**https://jsonapi.org/**

## Pagination:
  - by cursor (aka "absolute pagination")
  - cursor responsability: identify element of a collection, THAT'S IT! No filtering, no page size, etc.

Note: In a scenario where we nest like A -> B -> C, there is NO dependency from C on A !
  -> This matters for cursor pagination links in a relationship scenario

## JSON-api relationships
- Relationships links should be aliases on the resource when the relation IS a resource
- When it is an attribute (1 to 1 scenario) treat the suppresion of the relationship like an attribute update

## Notes:

- Every resource should be exposed as a top level endpoint (meaning: only one ID needs to be known to make a request).
Nesting is allowed but is purely an alias.

- POST for UPSERT

- GraphQL could be a valid alternative, but I think they lost conceptually. Would not try to discourage someone from using it, but I’m 90% sure JSON-api is a better choice :)


## Ressources:

### JSON:API Reset password
- https://discuss.jsonapi.org/t/how-to-model-a-password-reset-endpoint-and-its-parameters/869
- https://discuss.jsonapi.org/t/account-verification/607
- https://www.slideshare.net/MadsJensen22/protecting-your-apis-with-doorkeeper-and-oauth-20

### CSRF / Cookies / API

- https://security.stackexchange.com/questions/168230/csrf-protection-for-json-api-with-cookie-auth
- https://security.stackexchange.com/questions/166724/should-i-use-csrf-protection-on-rest-api-endpoints

### OAuth & Json:API

- https://discuss.jsonapi.org/t/json-api-response-format-for-non-resource-data-like-oauth-token/74/8





