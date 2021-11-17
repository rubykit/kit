class Kit::Auth::Components::Pages::Users::Settings::Oauth::SocialButtonsComponent < Kit::Auth::Components::Shared::SocialButtonsComponent

  def providers
    Kit::Auth::Services::Oauth.providers.select { |el| el[:group] == :web }.map do |provider|
      {
        name: I18n.t!("kit.auth.pages.users.oauth.#{ provider[:internal_name] }.submit"),
        icon: "fa-#{ provider[:internal_name] } fab-colored",
        url:  router_path(id: 'web|users|oauth|sign_in', params: { provider: provider[:external_name] }),
      }
    end
  end

end
