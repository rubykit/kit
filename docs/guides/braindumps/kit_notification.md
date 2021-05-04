
# Kit::Notifier

Technically a `Notification` is an endpoint called by `Kit::Router`, living in a given domain :)

`Kit::Notifier` is configured **PER application container** and contains:
- the logic to communicate with external services (emails, sms, user events feeds, etc)
- the preference / suppression logic

It is where you define where notifications end up being sent.





