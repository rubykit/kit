FactoryBot.define do

  factory :author, class: 'Kit::JsonApiSpec::Models::Write::Author' do

    name          { Faker::Book.author }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    date_of_death { (rand(1..10) == 5) ? Faker::Date.backward(days: rand(100..1000)) : nil }

  end

end
