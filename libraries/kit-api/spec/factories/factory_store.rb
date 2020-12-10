FactoryBot.define do

  factory :store, class: 'Kit::JsonApiSpec::Models::Write::Store' do

    name { Faker::Company.name }

  end

end
