# TODO

* RESEARCH: Should we have PLUGs ?!
  * The interesting thing is that any callable receiving a `request` object can probably considered a "plug".
  * Revisit the interface of `endpoints`. A connection `object` is probably a better primitive than `request` / `response`.
  * https://hexdocs.pm/jsonapi/readme.html
  * That's where the plug behaviour could be useful.

* WARNING:
  * The mountpoint resolution ARE NOT recomputed on chance
  * The whole logic in the store need to be rewritten properly.

* As of now:
  * The issue is: EP1 has 3 aliases: [AL1, AL2, AL3]. AL1 is mounted through MP1, AL2 through MP2, what is the URI of AL3?
  * Chaining (the "branch" approach) might not be the right representation. It might make more sense to use "alias grouping" if we can.
  * Simplest solution:
    * not care, allow chaining & ask for disambiguiation when MP collisions
    * provide a way to group endpoints when mounting?
    * if one of them is overidden latter, apply to the "group" (but explicit trumps implicit, so if second overide on one of the group, ask for disambiguiation ?)

* Investigate reload behaviour as it relates to get / post routes couple

* Research: what are the rules around endpoints / protocols ?
  * Why did I decide on `one alias` == `one mountpoint` ?
  * 1 alias = 1 mountpoint ? (and not 1 mountpoint per adapter type)
  * What are reasonable limitations of mouting the same endpoint N times? One per protocol? Being clear on a default one?

* Create store grouping (endpoints / aliases / mountpoints) to do dependency injection properly (like specs)

* Research: should the formatting happen inside the endpoint or in a `endpoint` <> `protocol` adapter ?

* Research: look at Plug again

* Create CLI tool to represent:
  * available endpoints
  * available aliases
  * available mountpoints
  * aliases that needs to be explicitely mounted (and provide default if an endpoint only has one mountpoint)
  * use types

* Add ActiveAdmin support? (or just start with Kit::Admin ?)

* Handle intents (redirect post sign-up / sign-in)

* API async middleware:
  * Async middleware that reacts to certain parameters (headers for "meta information")
  * https://jsonapi.org/recommendations/#asynchronous-processing

* RESEARCH: external visibility Web / Api / System (non mountable externally) !

* Add `.safe_delay` if redis is not available

* Add action_cable (what should the PUSH primitives look like ? Right now "return" is the "response")
  * https://blog.heroku.com/real_time_rails_implementing_websockets_in_rails_5_with_action_cable

* Add action_mailer