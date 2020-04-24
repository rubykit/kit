# TODO
TODOs of things that do not have their own gem.

* Loading:
  * Solve controller eager login at the kit-domain level
  * Solve plugin reloading

* RESEARCH: response format. Should it be nested instead of top level? (like `response: { content:, type:, meta: }`)

* How should we handle templates so that do not rely on rails rendering ?
  * Brainstorm layouts / Rails controller type issue!
  * Should this be solved when the router register things? (you can specify your own entry point?) (seems easiest)

* RESEARCH: act_as primitives
  * What helpers should be available in requests?
  * How should it be persited in events ?
  * How should we represent it in Analytics tool ? (send acting_user too && always compare acting_user == target_user ?)
  * Tentative implementation: `acting_user`, `acting_user_oauth_token`, `target_user`
  * What should be the way to send the user we are acting on behalf on in a query? (Header? Params?)

* Kit::ACL ?

* Kit::Admin
  * Filtering engine (is this the same than the JSON-API filtering engine ?)
  * Filter component
  * Brainstorm "Tables" implementation (probably split data & presentation)

  * https://vimeo.com/305601486/a1388ac3a9
  * https://demo.webpixels.io/quick-website-ui-kit-v1.0.0/docs/styleguide/colors.html
  * https://demo.webpixels.io/quick-website-ui-kit-v1.0.0/docs/index.html

* Kit::Events
  * Add a "store" (like in router & organizer) so that every engine can register specific targets for an event ?
  * There probably needs to be a concept of "categories" or "type of targets" (like :notifications, :email_notifications, :analytics, etc)
  * Settle on a way to persist
  * How should the event be processed? What does that event bus looks like / is it local?
  * Blacklist certain attributes (like auth_token) so that they only get sent to the services that requires them
  * How to process event? 2 behaviours: sync / async that are explicit? consumed_at on the event? (or should we trust Sidekiq?)

* Kit::Errors
  * Write JSON::Api adapter (title, desc, status)
  * Handle message generation with I18n support

* API / JSON-api
  * Relationship VS Resources. Implement as alias to resources links when not an attribute (not a belongs_to) ?
  * Implement filtering
  * Implement endpoint aliasing (when nesting)
  * What happens when the resource is on another API ? (aka: the model is not side loadable) >> Mostly routing but embed implications

* Kit::Notifications (user notifications, emails, push, text)
  * Add sync to / from external providers
  * Notifications / preferences handling ?
  * Related to Kit::Events categories / pub-sub mechanism

* Kit::Env
  * What should this even look like?
  * Handling per engine (auto prefixing + multifile file system >> handle N config type at once)

* Kit::PubSub ?
  * Postgres!
  * Redis
  * Look into action cable adapters
  * Primitives: real time, no replay

* Add rate limit


- Figure out how to use kit-auth engine view path for doorkeeper engine

- Geolocation >> add geocoder + GeoLite2 City database

- Add rate limit


