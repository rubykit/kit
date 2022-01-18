module Helpers::Omniauth::Linkedin

  def omniauth_linkedin_mock(omniauth_strategy:, app_id: nil, provider_uid: nil, email: nil, lastname: nil, firstname: nil, image: nil, expires_at: nil)
    provider_uid ||= Faker::Number.number(digits: 15)
    app_id       ||= ENV['OAUTH_LINKEDIN_APP_ID'] || Faker::Number.number(digits: 10)

    expires_at ||= (DateTime.now + 1.month).to_i
    expires    = !!expires_at
    token      = 'token'

    info = {
      email:       email     || Faker::Internet.email,
      picture_url: image     || Faker::Avatar.image,
      last_name:   lastname  || Faker::Name.last_name,
      first_name:  firstname || Faker::Name.first_name,
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
