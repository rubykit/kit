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

`standard_fields`: `id` `created_at` `updated_at`

| **UserAuth** | *Top level model, mostly useful for the relationships.* |
| --- | --- |
| FIELDS | `standard_fields` |
| GET | ✅ restriction: `owner_only` |
| POST | ❌ *not sure?* |
| PUT | ✅ *but no fields yet?* |
| DELETE | ✅ with special scope on token |

| **UserEmail** | *Allow to update email + verify the email (with a token having the correct scopes).* |
| --- | --- |
| FIELDS | `standard_fields` `user_id` `email` `verified` `primary` |
| GET | ✅ restriction: `owner_only` |
| POST | ✅ `email` |
| PUT | ✅ `verified` `primary` |
| DELETE | ✅ *with special scope on token?* |

| **UserSessions** | *Inspect current sessions & disable them.* |
| --- | --- |
| FIELDS | `standard_fields` `last_used_at` `location` `device` |
| GET | ✅ restriction: `owner_only` |
| POST | ❌ |
| PUT | ❌ |
| DELETE | ✅ |

| **UserSecret** | *Update account password.* |
| --- | --- |
| FIELDS | `standard_fields` `revoked` `expires_at` |
| GET | ❌ |
| POST | ✅ with special scope on token |
| PUT | ❌ |
| DELETE | ❌ |

| **UserAccount** | *Hack to create an account in an easier way. Sideload UserAuth, UserEmail, UserAuthToken* |
| --- | --- |
| FIELDS | `standard_fields` `revoked` `expires_at` |
| GET | ❌ |
| POST | ✅ `email` `secret` |
| PUT | ❌ |
| DELETE | ❌ |

| **UserAuthToken** | *Sign in.* |
| --- | --- |
| FIELDS | `standard_fields` `revoked` `expires_at` |
| GET | ❌ |
| POST | ✅ `email` `secret` |
| PUT | ❌ |
| DELETE | ❌ |

### `UserAuthToken`
- **Source**: `OauthTokens` model with specific scopes: [:all]
- **Fields**: `id scope token`
- **Read**:   ❌ (the actual token is hashed afer this)
- **Write**:  CREATE

### `UserAuthTokenAsync`
- **Source**: `OauthTokens` model with specific scopes: [:reset_password, :magic_sign_in_link]
- **Fields**: `id scope`
- **Read**:   ❌
- **Write**:  CREATE (to request a token by email)

--------------------

Not really part of this

### `UserProfile`
- **Source**: `Users` model
- **Fields**: `id created_at username avatar`
- **Read**:   Public
- **Write**:  The current user can update the properties


## Actions

- **User signup**: CREATE UserAccount (OR: CREATE UserAuth + CREATE UserSecret + CREATE Email in one call or not)
- **User signin**: CREATE UserAuthToken
- **Update emails**: PUT UserEmails.email
- **Update password**: PUT UserSecret.secret
- **Confirm emails**: PUT UserEmails.confirmed with scope :confirm_email
- **Reset password**: CREATE UserAuthTokenAsync with scope :reset_password
- **Magic sign-in link**: CREATE UserAuthTokenAsync with scope :magic_sign_in_link
- **Disable active sessions**: DELETE UserSessions