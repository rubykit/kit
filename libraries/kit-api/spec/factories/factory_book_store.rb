FactoryBot.define do

  factory :book_store, class: 'Kit::JsonApiSpec::Models::Write::BookStore' do

    association :book
    association :store

    in_stock { true }

  end

end
