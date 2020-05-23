RSpec.shared_context 'config dummy app' do

  let(:config_dummy_app) do
    Kit::Api::JsonApi::Services::Config.default_config({
      resources:     {
        author:     Kit::JsonApiSpec::Resources::Author.to_h,
        book:       Kit::JsonApiSpec::Resources::Book.to_h,
        book_store: Kit::JsonApiSpec::Resources::BookStore.to_h,
        chapter:    Kit::JsonApiSpec::Resources::Chapter.to_h,
        photo:      Kit::JsonApiSpec::Resources::Photo.to_h,
        serie:      Kit::JsonApiSpec::Resources::Serie.to_h,
        store:      Kit::JsonApiSpec::Resources::Store.to_h,
      },
      page_size:     3,
      page_size_max: 5,
    })
  end

end
