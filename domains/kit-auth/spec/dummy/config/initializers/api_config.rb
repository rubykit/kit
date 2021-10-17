DUMMY_APP_API_CONFIG = Kit::Api::Services::Config.create_config(
  resources:     {
    user_auth:  Kit::Auth::Resources::Api::UserAuth.to_h,
    user_email: Kit::Auth::Resources::Api::UserEmail.to_h,
  },
  page_size:     25,
  page_size_max: 50,
  meta:          {
    kit_api_paginator_cursor: {
      encrypt_secret: ENV['API_PAGINATOR_SECRET'],
    },
  },
)

# AwesomePrint nesting setup: this avoids huge unreadable object dumps
DUMMY_APP_API_CONFIG[:resources].each do |_k, v|
  v.__ap_log_name__ = ->(object) { "(Resource##{ object[:name].to_s.capitalize })" } if v.respond_to?(:'__ap_log_name__=')
  v.__ap_nest__     = true                                                           if v.respond_to?(:'__ap_nest__=')
end
