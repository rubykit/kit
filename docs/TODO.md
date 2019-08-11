- API / JSON-api
  -> Relationship VS resources. Implement as alias to resources links when not an attribute (not a belongs_to)
  -> What happens when the resource is on another API ? (aka: the model is not side loadable)

- ENV handling per engine (auto prefixing + multifile file system >> handle N config type at once)

- Kit::Router:
  - View helper (verb aware link to)
  - Add ActiveAdmin support !


- Errors hash: establish format, probably like:
  [:error, errors: [{ attr: :email, msg: "is already taken" }], { msg: "Incorrect password or non existing user"}]]

- Forms helpers (as it relates to errors)

- Integrate Event store?



- Investigate partial eager_loading

- Views: auto add class that matches the name of the cell? If so, on which element?

- Figure out how to use kit-auth engine view path for doorkeeper engine
