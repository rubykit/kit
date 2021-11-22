FactoryBot.define do

  factory :user_oauth_identity, class: 'Kit::Auth::Models::Write::UserOauthIdentity' do

    user

    provider_uid { Faker::Alphanumeric.alphanumeric(number: 10) }

  end

end
