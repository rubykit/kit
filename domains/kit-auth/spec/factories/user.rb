FactoryBot.define do

  factory :user, class: 'Kit::Auth::Models::Write::User' do
    email         { Faker::Internet.email }

    transient do
      password { 'xxxxxx' }
    end

    hashed_secret { Kit::Auth::Services::Password.generate_hashed_secret(password: password)[1][:hashed_secret] }
  end

end
