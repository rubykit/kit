KIT_DUMMY_APP_API_CONFIG = Kit::Api::Services::Config.create_config({
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
  meta:          {
    kit_api_paginator_cursor: {
      encrypt_secret: '72b035a267ac10c7b5e3c0893c395ab0',
    },
  },
})

# AwesomePrint nesting setup: this avoids huge unreadable object dumps
KIT_DUMMY_APP_API_CONFIG[:resources].each do |_k, v|
  v.__ap_log_name__ = ->(object) { "(Resource##{ object[:name].to_s.capitalize })" } if v.respond_to?(:'__ap_log_name__=')
  v.__ap_nest__     = true                                                           if v.respond_to?(:'__ap_nest__=')
end
