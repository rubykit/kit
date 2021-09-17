<!--pp {} -->
<img align="left" width="50" height="90" src="https://raw.githubusercontent.com/rubykit/kit/master/libraries/kit-router/docs/assets/images/kit-router.logo.svg">
<!-- pp-->

[Kit::Router]: https://github.com/rubykit/kit/tree/master/libraries/kit-router

# Kit::Router

[Kit::Router] makes `endpoints` available through various `adapters` and ensures message deliveries between domains.

It adds a layer of indirection to allow easy domain extensibility.

- To learn more about [Kit::Router], see [Kit::Router's documentation](https://docs.rubykit.org/kit-router/edge).
- To understand how we think about routing, see the [About Routing](docs/guides/about.md) guide.
- To learn how to use [Kit::Router] in your projects, see the [Usage](docs/guides/usage.md) guide.

## Adapters

Implemented adapters:

* HTTP:
  *  `Kit::Router::Adapters::HttpRails`
* INLINE:
  * `Kit::Router::Adapters::InlineBase`
* ASYNC:
  * `Kit::Router::Adapters::AsyncRails` 
* MAILER:
  * `Kit::Router::Adapters::MailerRails`

## Copyright & License

Copyright (c) 2021, Nathan Appere.

[Kit::Router] is licensed under [MIT License](MIT_LICENSE.md).
