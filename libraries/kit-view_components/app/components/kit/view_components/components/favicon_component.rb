# Favicon component
#
# ## Usage
#
# The process is not ideal but it only needs to be done once per logo update, so it's acceptable.
#
# - Generate a `config/favicon.json` file on https://realfavicongenerator.net/favicon/ruby_on_rails
# - Add it to your project
# - Update `master_picture` to be the relative path to your main logo (ideally svg)
# - Run `rails generate favicon`
# - Move the generated assets where you need to
# - Update `favicon.en.yml` to:
#    - reflect the path that will be used by `asset_url`
#    - set the path of your svg icon (if any)
#    - copy 3 values from `favicon.json`: `windows.background_color`, `android_chrome.theme_color`, `safari_pinned_tab.theme_color` (needed by this component template)
# - Update `browserconfic.xml.erb` & `site.webmanifest.erb` files usage of `asset_url` to account for the real icon path.
# - Add these 2 files to your `manifest.js` for Sprocket.
# - Copy `favicon.ico` to your public directory.
#
# ## Refs:
# - https://realfavicongenerator.net/favicon/ruby_on_rails
# - https://dev.to/masakudamatsu/favicon-nightmare-how-to-maintain-sanity-3al7
#
class Kit::ViewComponents::Components::FaviconComponent < Kit::ViewComponents::Components::BaseComponent

  attr_reader :router_conn, :i18n_prefix

  def initialize(*, router_conn:, i18n_prefix:, **)
    super

    @router_conn = router_conn
    @i18n_prefix = i18n_prefix
  end

  def favicon_svg_url
    @favicon_svg_path ||= I18n.t("#{ i18n_prefix }.favicon.svg")

    @favicon_svg_path ? asset_url(@favicon_svg_path) : nil
  end

  def favicon_path(asset)
    @favicon_path ||= I18n.t("#{ i18n_prefix }.favicon.path")

    asset_url("#{ @favicon_path }/#{ asset }")
  end

  def safari_pinned_tab_theme_color
    I18n.t("#{ i18n_prefix }.favicon.safari_pinned_tab.theme_color")
  end

  def windows_tile_color
    I18n.t("#{ i18n_prefix }.favicon.windows.tile_color")
  end

  def android_chrome_theme_color
    I18n.t("#{ i18n_prefix }.favicon.android_chrome.theme_color")
  end

  def ios_app_name
    I18n.t("#{ i18n_prefix }.favicon.ios.app_name")
  end

  def app_name
    I18n.t("#{ i18n_prefix }.favicon.app_name")
  end

end
