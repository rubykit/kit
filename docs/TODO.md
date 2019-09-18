- General
  - Audit response format. Should it be nested instead of top level? (like `response: { content:, type:, meta: }`)
  - How should we handle templates so that we do not rely on rails rendering ?
  - Brainstorm act_as primitives
    - What helpers should be available in requests?
    - How should it be persited in events ?
    - How should we represent it in Analytics tool ? (send acting_user too && always compare acting_user == target_user ?)
    - Tentative implementation: `acting_user`, `acting_user_oauth_token`, `target_user`
    - What should be the way to send the user we are acting on behalf on in a query? (Header? Params?)
  - Brainstorm layouts / Rails controller type issue!
    - Should this be solved when the router register things? (you can specify your own entry point?) >> This is easiest

- ACL engine ?

- Kit::Admin
  - Filtering engine (is this the same than the JSON-API filtering engine ?)
  - Filter component
  - Brainstorm "Tables" implementation (probably split data & presentation)

- Kit::Pagination
  - Add "relative" pagination (per page idx). Will be useful in Admin.

- Kit::Organizer
  - Assess how to chain "flows" (cf: actions that need to be called regardless of the status of a previous flow). Not sure the tupple format serves us here.
  - Would replacing the tupple format with only a ctx with status: key help ?
  - The hash format would allow to have "flow metadata" (like explicit "stop" instead of :ok_stop)
  - Should this just be N call to organize ? (the danger I see is: easy to make a mistake and chain the organized calleables to get the context feeding behaviour even though they are not purely linear) >> Answer: if named flowed, no linearization, each new call to organize creates a new named flow. The glue just becomes: what is exposed from one flow to another, an on what conditions

  - Should "organize" help represent higher order flows with branching ?
  - Is the role of railway programming to ALWAYS go back to a ":ok" path for the caller ?

  - There is something really promising in "flows" categorisation & code representation (would there be a way to know the full flow of a program at parsing time ?! >> NOPE. (or maybe with an explicit analysis mode on EVERY calleable))

- Event store
  - Settle on a way to persist
  - How should the event be processed? What does that event bus looks like / is it local?
  - Blacklist certain attributes (like auth_token) so that they only get sent to the services that requires them
  - How to process event? 2 behaviours: sync / async that are explicit? consumed_at on the event? (or should we trust Sidekiq?)

- Kit::Events
  - Add a "store" (like in router & organizer) so that every engine can register specific targets for an event ?
  - There probably needs to be a concept of "categories" or "type of targets" (like :notifications, :email_notifications, :analytics, etc)

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
  - Use activejob && add explicit endpoint ? (rather than "async")

  - API async middleware:
    - Async middleware that reacts to certain parameters (headers for "meta information")
    - https://jsonapi.org/recommendations/#asynchronous-processing

  - Start to categorize: Web / Api / System (non mountable externally) !
  - Add `.safe_delay` if redis is not available
  - IMPORTANT: the controller / entry point that process a router call is only a MOUNTING concern! It should NOT leak on registration! This solves a lot of issues!

  - Add action_cable (what should the PUSH primitives look like ? Right now "return" is the "response")
    -> https://blog.heroku.com/real_time_rails_implementing_websockets_in_rails_5_with_action_cable
  - Add action_mailer


- Kit::Notifications (user notifications, emails, push, text)
  - Add sync to / from external providers
  - Notifications / preferences handling ?
  - Related to Kit::Events categories / pub-sub mechanism


- Kit::Organizer
  - Research "Never" monad with error reporting (:error is transformed to :ok for flow purposes, but the error is reported / saved?)
  - Investigate other return status, like :stop, :ok_stop ? ("should stop but isn't technically an error")
  - To make contracts work:
      - disable one to many (pattern matching) indirection
      - when decorating one to one, add `is_decorated?` `decorated_method` primitive to be able to access original signature

- Kit::Env
  - Handling per engine (auto prefixing + multifile file system >> handle N config type at once)
  - What should this even look like?

- Kit::PubSub ?
  - Postgres!
  - Redis
  - Look into action cable adapters
  - Primitives: real time, no replay

- Kit::Store
  - Table like definitions backed by arrays or hashes ?
  - Non distributed / non thread safe
  - Handles: "foreign keys" / join tables / constraints
  - "Indexing" ?
  - Designed for read, not write
  - Returns deep copy of data ?

- Loading:
  - Solve controller eager login at the kit-domain level
  - Solve plugin reloading

- Figure out how to use kit-auth engine view path for doorkeeper engine

- Geolocation >> add geocoder + GeoLite2 City database

- Add rate limit

- Investigate reload behaviour as it relates to get / post routes couple
