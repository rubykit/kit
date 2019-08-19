- Kit::Errors
  - Write JSON::Api adapter (title, desc, status)
  - Handle message generation with I18n support

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
  - Add alias registration with uid to redefine in container

  - Async implementation:
    - Async middleware that reacts to certain parameters (headers for "meta information")
    - https://jsonapi.org/recommendations/#asynchronous-processing

- Event store
  - Settle on a way to persist
  - How should the event be processed? What does that event bus looks like / is it local?
  - Blacklist certain attributes (like auth_token) so that they only get sent to the services that requires them

- ENV handling per engine (auto prefixing + multifile file system >> handle N config type at once)
  - What should this even look like?

- Loading:
  - Solve controller eager login at the kit-domain level
  - Solve plugin reloading

- Figure out how to use kit-auth engine view path for doorkeeper engine

- Geolocation >> add geocoder + GeoLite2 City database

- Add rate limit

- Investigate reload behaviour as it relates to get / post routes couple