# Formatting helpers for `JSON::API`
#
# A JSON::API example:
# ```json
#   {
#     "errors": [
#       {
#         "status": "422",
#         "source": { "pointer": "/data/attributes/firstName" },
#         "title":  "Invalid Attribute",
#         "detail": "First name must contain at least three characters."
#       }
#     ]
#   }
# ```
#
## ### References
# - https://jsonapi.org/examples/#error-objects
module Kit::Error::Format::JsonApi
end
