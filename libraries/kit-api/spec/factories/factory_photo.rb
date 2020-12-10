FactoryBot.define do

  factory :photo, class: 'Kit::JsonApiSpec::Models::Write::Photo' do

    title  { Faker::Book.title }
    uri    { Faker::Avatar.image }

    for_book

    trait :for_author do
      association(:imageable, factory: :author)
    end

    trait :for_book do
      association(:imageable, factory: :book)
    end

    trait :for_chapter do
      association(:imageable, factory: :chapter)
    end

  end

end
