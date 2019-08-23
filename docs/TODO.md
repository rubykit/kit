- Event store
  - Settle on a way to persist
  - How should the event be processed? What does that event bus looks like / is it local?
  - Blacklist certain attributes (like auth_token) so that they only get sent to the services that requires them
  - How to process event? 2 behaviours: sync / async that are explicit? consumed_at on the event? (or should we trust Sidekiq?)

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
  - What are reasonable limitations of mouting the same endpoint N times? One per protocol? Being clear on a default one?
  - Create Adpaters like http_web / http_api

  - Async implementation:
    - Async middleware that reacts to certain parameters (headers for "meta information")
    - https://jsonapi.org/recommendations/#asynchronous-processing

- Admin
  - Add "act as" log (to know who actually did the action VS what the target was)

- Notifications engine?
  - Add sync to / from external providers

- ENV handling per engine (auto prefixing + multifile file system >> handle N config type at once)
  - What should this even look like?

- Kit::Organizer
  - Research "Never" monad with error reporting (:error is transformed to :ok for flow purposes, but the error is reported / saved?)
  - Investigate other return status, like :stop, :ok_stop ? ("should stop but isn't technically an error")

- Loading:
  - Solve controller eager login at the kit-domain level
  - Solve plugin reloading

- Figure out how to use kit-auth engine view path for doorkeeper engine

- Geolocation >> add geocoder + GeoLite2 City database

- Add rate limit

- Investigate reload behaviour as it relates to get / post routes couple