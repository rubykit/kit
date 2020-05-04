- Switch to hashed secrets
  - In Actions (might already be hashed in the DB)
  - Settle on 2 objects types, one with the secret (only available on creation), one without

- Add reset password
  - How should this work with 2step auth?
  - To prevent timing attack, we should make sure that only the event is created in a sync way, not the tokens.

- Add one time log in link
  - LINK: https://hackernoon.com/magic-links-d680d410f8f7
  - LINK: https://medium.com/@kelvinvanamstel/should-we-embrace-magic-links-and-leave-passwords-alone-c73db7007fc4
  - LINK: https://coderwall.com/p/qw7hwq/effortless-two-factor-authentication-in-rails
  - LINK: https://github.com/heapsource/active_model_otp
  - How should this work with 2step auth?

- Add confirmation

- Add omniauth support

- Add two step auth support
  - Through authenticator app
    - LINK: https://coderwall.com/p/qw7hwq/effortless-two-factor-authentication-in-rails
  - Through SMS ?
  - Through email ?
  - Add recovery codes ?
