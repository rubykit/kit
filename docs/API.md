
JSON API
https://jsonapi.org/

Pagination:
    - absolute (by value, with support for multi-fields, like 1datetime, 2id), relative (by offset/index)
    - with clear values (passed as is in parameters) or encapsulated through a token (I think this is what “cursor” should refer to, regardless of the type of pagination)
    - when using a cursor, should sparse fields or limit be embedded in the token?
    - when duplicates (clear values + token), which wins?
  https://jsonapi.org/extensions/##profiles-category-pagination

In a scenario where we nest like A -> B -> C, there is NO dependency from C on A !
  -> This matters for cursor pagination links in a relationship scenario

JSON-api relationships
- Relationships links should be aliases on the resource when the relation IS a resource
- When it is an attribute (1 to 1 scenario) treat the suppresion of the relationship like an attribute update

- Every resource should be exposed as a top level endpoint (meaning: only one ID needs to be known to make a request).
Nesting is allowed but is purely an alias.

- POST for UPSERT


Notes:

- GraphQL could be a valid alternative, but I think they lost conceptually. Would not try to discourage someone from using it, but I’m personally 90% sure JSON-api is a better choice.


Ressources:

JSON:API Reset password
- https://discuss.jsonapi.org/t/how-to-model-a-password-reset-endpoint-and-its-parameters/869
- https://discuss.jsonapi.org/t/account-verification/607
- https://www.slideshare.net/MadsJensen22/protecting-your-apis-with-doorkeeper-and-oauth-20

CSRF / Cookies / API

https://security.stackexchange.com/questions/168230/csrf-protection-for-json-api-with-cookie-auth
https://security.stackexchange.com/questions/166724/should-i-use-csrf-protection-on-rest-api-endpoints

OAuth & Json:API

https://discuss.jsonapi.org/t/json-api-response-format-for-non-resource-data-like-oauth-token/74/8





