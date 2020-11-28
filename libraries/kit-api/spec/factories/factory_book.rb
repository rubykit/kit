FactoryBot.define do

  factory :book, class: 'Kit::JsonApiSpec::Models::Write::Book' do

    association :author
    association :serie

    title          { Faker::Book.title }
    date_published { Faker::Date.backward(days: rand(100..600)) }

  end

end
