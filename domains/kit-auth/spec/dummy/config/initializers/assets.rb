# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
if defined?(::ActiveAdmin)
  Rails.application.config.assets.precompile += %w[active_admin.js active_admin.css]
end

Rails.application.config.assets.precompile += %w[kit_auth_dummy_application.js kit_auth_dummy_application.css]
Rails.application.config.assets.precompile += %w[kit_auth_dummy_vendor.js      kit_auth_dummy_vendor.css]
