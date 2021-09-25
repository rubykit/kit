# Authentication & authorization API

## Questions
- Should we support multi-emails out of the box?
- Sould we treat password as just a token with a type? (same for reset code)

## DB Models

### Users

`id created_at username hashed_secret avatar` (+ 2 step auth otp_fields)

Should `hashed_secret` just be a `Token` with a specific type?

### UsersEmails ?

`id created_at user_id email primary confirmed_at`

### OauthTokens

`id created_at user_id hashed_secret scope last_used_at`

### UsersPhoneNumbers ?

`id created_at user_id phone primary confirmed_at`

## API Ressources

All the ressources described here are backed by the two DB models above.

Ideally, we want to be able to:
- Return a full object when authorized (and not only specific fields). That way, you don't have to track the state of models per attributes in the client, it can be per model directly (Ex: "model not in the store? fetch!" rather than "attributes not in the model? reload with correct authorization!")

- Avoid "write only" attributes: in that case we can create a model that is never returned.

- Avoid attributes that have different authorization strategy: it's easier to do it on the resource directly.


### `UserAuth`
- **Source**: `Users` model
- **Fields**: `id created_at last_accessed_at two_factors_enabled` (top level model, mostly useful for the relationships)
- **Read**:   only the current user has acces to this model
- **Write**:  UNAVAILABLE (or primary email if we want decide not to use UserEmail)

### `UserEmail`
- **Source**: `UsersEmails` model
- **Fields**: `id user created_at email email_verified primary`
- **Read**:   only the current user has acces to this model
- **Write**:  allow to update email + verify the email (thanks to a token with a specific scope)

### `UserSecret`
- **Source**: `Users` model
- **Fields**: `id secret secret_confirmation` (+ otp_secret for 2 steps auth)
- **Read**:   UNAVAILABLE
- **Write**:  `CREATE UPDATE` to set the account password.

### `UserAccount`
- **Source**: `Users` + `UsersEmails` models
- **Fields**: `id email email_verification secret secret_verification`
- **Read**:   UNAVAILABLE
- **Write**:  CREATE only (this is a Json:Api hack to abstract the UserAuth + UserEmail + UserSecret complexity to the client, with GraphQL this is not an issue)

### `UserSessions`
- **Source**: `OauthTokens` model with the generic access scope.
- **Fields**: `id created_at last_used_at location device`
- **Read**:   only the current user has acces to this model
- **Write**:  `DELETE` to remove the token

### `UserProfile`
- **Source**: `Users` model
- **Fields**: `id created_at username avatar`
- **Read**:   Public
- **Write**:  The current user can update the properties

### `UserAuthToken`
- **Source**: `OauthTokens` model with specific scopes: [:all]
- **Fields**: `id scope token`
- **Read**:   Only as a response to CREATE! (because the actual token is hashed afer this)
- **Write**:  CREATE

### `UserAuthTokenAsync`
- **Source**: `OauthTokens` model with specific scopes: [:reset_password, :magic_sign_in_link]
- **Fields**: `id scope`
- **Read**:   UNAVAILABLE
- **Write**:  CREATE (to request a token by email)

## Actions

- **User signup**: CREATE UserAccount (OR: CREATE UserAuth + CREATE UserSecret + CREATE Email in one call or not)
- **User signin**: CREATE UserAuthToken
- **Update emails**: PUT UserEmails.email
- **Update password**: PUT UserSecret.secret
- **Confirm emails**: PUT UserEmails.confirmed with scope :confirm_email
- **Reset password**: CREATE UserAuthTokenAsync with scope :reset_password
- **Magic sign-in link**: CREATE UserAuthTokenAsync with scope :magic_sign_in_link
- **Disable active sessions**: DELETE UserSessions