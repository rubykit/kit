module Helpers::Omniauth; end

module Helpers::Omniauth::Facebook

  def omniauth_facebook_mock(omniauth_strategy:, app_id: nil, provider_uid: nil, email: nil, name: nil, image: nil, expires_at: nil)
    provider_uid ||= Faker::Number.number(digits: 15)
    app_id       ||= ENV['OAUTH_FACEBOOK_APP_ID'] || Faker::Number.number(digits: 10)

    expires_at ||= (DateTime.now + 1.month).to_i
    expires    = !!expires_at
    token      = 'token'

    info = {
      email: email || Faker::Internet.email,
      name:  name  || Faker::Name.name,
      image: image || Faker::Avatar.image,
    }

    credentials = {
      token:      token,
      expires_at: expires_at,
      expires:    expires,
    }

    raw_info = info.dup

    payload = {
      provider:    omniauth_strategy.to_s,
      uid:         provider_uid,
      info:        info,
      credentials: credentials,
      extra:       {
        raw_info: raw_info,
      },
      app_id:      app_id,
    }

    OmniAuth::AuthHash.new(payload)
  end

end
