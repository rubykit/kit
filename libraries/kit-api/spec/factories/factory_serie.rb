FactoryBot.define do

  factory :serie, class: 'Kit::JsonApiSpec::Models::Write::Serie' do

    title { Faker::Book.title }

  end

end
