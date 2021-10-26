if defined?(::ActiveAdmin)

  ::ActiveAdmin.setup do |config|

  ::ActiveAdmin.setup do |config|
    config.namespace :kit_auth do |admin|
      admin.route_prefix = 'admin'
    end
   end

    #config.site_title = "Admin"
    # config.site_title_link = "/"
    # config.site_title_image = "logo.png"
    # config.favicon = 'favicon.ico'

    config.display_name_methods = [:model_verbose_name]

    #config.root_prefix = 'admin'

    # config.authorization_adapter = ActiveAdmin::CanCanAdapter
    # config.pundit_default_policy = "MyDefaultPunditPolicy"
    # config.pundit_policy_namespace = :admin
    # config.cancan_ability_class = "Ability"
    # config.on_unauthorized_access = :access_denied

    # config.current_user_method = :current_admin_user

    # config.logout_link_path = :destroy_admin_user_session_path
    # config.logout_link_method = :get

    # config.root_to = 'dashboard#index'

    config.comments = false
    # config.comments_registration_name = 'AdminComment'
    # config.comments_order = 'created_at ASC'
    config.comments_menu = false
    # config.comments_menu = { parent: 'Admin', priority: 1 }

    config.batch_actions = false

    # config.before_action :do_something_awesome
    config.filter_attributes = [:hashed_secret, :password, :password_confirmation]

    config.localize_format = :long

    # == Meta Tags
    #   config.meta_tags = { author: 'My Company' }
    #   config.meta_tags_for_logged_out_pages = {}

    # config.breadcrumb = false

    # config.create_another = true

    #   config.register_stylesheet 'my_stylesheet.css'
    #   config.register_stylesheet 'my_print_stylesheet.css', media: :print
    #   config.register_javascript 'my_javascript.js'

    # config.csv_options = { col_sep: ';' }
    # config.csv_options = { force_quotes: true }

    # config.default_per_page = 30
    # config.max_per_page = 10_000

    # config.filters = true
    config.include_default_association_filters = false

    # config.head = ''.html_safe
    # config.footer = 'my custom footer text'

    # config.order_clause = MyOrderClause
  end

end