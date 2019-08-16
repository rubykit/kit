- Forms helpers
  - Values https://cucumbersome.net/2016/09/06/rails-form-objects-with-dry-rb/ ?
  - Errors

- Errors
  - Move Kit::Errors to its own gem
  - Write JSON::Api adapter (title, desc, status, )

- API / JSON-api
  -> Relationship VS Resources. Implement as alias to resources links when not an attribute (not a belongs_to) ?
  -> Implement filtering
  -> Implement endpoint aliasing (when nesting)
  -> What happens when the resource is on another API ? (aka: the model is not side loadable) >> Mostly routing but embed implications

- Kit::Router
  - Add ActiveAdmin support !
  - Handle intents (redirect post sign-up / sign-in)
  - Handle resources in different apps (umounted ?)
  - Redo Plug on the long run.

  - Async implementation:
    - Async middleware that reacts to certain parameters (headers for "meta information")
    - https://jsonapi.org/recommendations/#asynchronous-processing

- Event store
  - Settle on a way to persist
  - How should the event be processed? What does that event bus looks like / is it local?

- ENV handling per engine (auto prefixing + multifile file system >> handle N config type at once)
  - What should this even look like?

- Loading:
  - Solve controller eager login at the kit-domain level
  - Solve plugin reloading

- Figure out how to use kit-auth engine view path for doorkeeper engine

- Geolocation >> add geocoder + GeoLite2 City database