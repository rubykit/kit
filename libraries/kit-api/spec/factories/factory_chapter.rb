FactoryBot.define do

  factory :chapter, class: 'Kit::JsonApiSpec::Models::Write::Chapter' do

    association :book

    title       { Faker::Book.title }

    sequence    :index
  end

end
