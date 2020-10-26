require_relative '../dummy/config/initializers/api_config'

RSpec.shared_context 'config dummy app' do

  let(:config_dummy_app) { KIT_DUMMY_APP_API_CONFIG.deep_dup }

  let(:config_dummy_app_ar_models) do
    {
      author:     Kit::JsonApiSpec::Models::Write::Author,
      book:       Kit::JsonApiSpec::Models::Write::Book,
      book_store: Kit::JsonApiSpec::Models::Write::BookStore,
      chapter:    Kit::JsonApiSpec::Models::Write::Chapter,
      photo:      Kit::JsonApiSpec::Models::Write::Photo,
      serie:      Kit::JsonApiSpec::Models::Write::Serie,
      store:      Kit::JsonApiSpec::Models::Write::Store,
    }
  end

end
