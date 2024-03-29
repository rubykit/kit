# About Routing

Most frameworks create "per protocols" ways to route calls from the outside world to the function responsible for the action. For instance, Rails will use Controllers for web pages & APIs, ActiveJobs for asyncs actions, ActionCable for WebSockets, Active? for Emails, etc.

We believe this behaviour leads to extra complexity and hinders extensibility.

As a result, Kit "endpoints" can be exposed through a varierty of protocols / behaviour with no change, it is the routing layer responsability to connect these endpoints to the outside world.

For instance, any endpoint can be made async without changing anything in the code.

## Endpoints

An `endpoint` is an entry-point that can be called from the outside of the application. It is a simple callable that accepts a `request object`, and returns a `response object`.

Every `endpoint` is registered against the `Router` with a unique `id`.

## Aliases

An `alias` is an indirection on an `endpoint`. This helps domains provides overridable behaviours.

For instace, `Kit::Auth` contains a default sign in web page, aliased through `web|users|sign_in`. If your domain has its own sign in page, you can alias `web|users|sign_in` to point to your own endpoint, without breaking any of the underlying logic of `Kit::Auth`.

## Adapters

An `andapter` defines how an endpoint will be exposed to the outside world, or called internally.

Currently the following are implemented:
* HTTP:
  *  `Kit::Router::Adapters::HttpRails`
* INLINE:
  * `Kit::Router::Adapters::InlineBase`
* ASYNC:
  * `Kit::Router::Adapters::AsyncRails` 
* NOTIFICATIONS:
    * MAILER:
      * `Kit::Router::Adapters::MailerRails`

Future candidates include:
  - WEBSOCKETS
  - NOTIFICATIONS:
    - `Sms`
    - `Mailboxes` (inbound emails)
  - ASYNC:
    - `AsyncAPI`: make any call to an API endpoint async
    - `RabbitMQ`
    - `Kafka`
    - `Spark`

## Mountpoints

A `mountpoint` exposes an `endpoint` (or one of its `aliases`) to the outside world through a given adapter.

Note: while the same endpoint can be exposed through several mountpoints (with smimilar or different adapters) an alias can only be attached to one mountpoint.
This prevents ambiguity when accessing an alias external ID through a mountpoint. (ex: if one alias has 2 http mountpoints, how do I know which one should be used when asking for the URL of that alias?)
