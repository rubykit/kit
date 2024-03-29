module Kit::ViewComponents::Middlewares::Meta

  # rubocop:disable Style/HashSyntax, Style/LambdaCall
  def self.call(router_conn:, i18n_prefix:)
    rails_controller = router_conn.metadata.dig(:adapters, :http_rails, :rails_controller)
    rails_request    = router_conn.metadata.dig(:adapters, :http_rails, :rails_request)
    current_url      = rails_request.url

    t = ->(key) { I18n.t("#{ i18n_prefix }.#{ key }") }
    l = ->(key) { rails_controller&.helpers&.asset_url(t.(key)) rescue '' } # rubocop:disable Style/RescueModifier

    router_conn[:metadata][:meta] = {
      :title                 => t.('meta.title'),
      :keywords              => t.('meta.keywords'),
      :description           => t.('meta.description'),

      :application_name      => t.('meta.application_name'),

      :'og:description'      => t.('meta.og.description'),
      :'og:image'            => l.('meta.og.image'),
      :'og:title'            => t.('meta.og.title'),
      :'og:url'              => current_url,

      :'twitter:description' => t.('meta.twitter.description'),
      :'twitter:image'       => l.('meta.twitter.image'),
      :'twitter:site'        => current_url,
      :'twitter:title'       => t.('meta.twitter.title'),
    }

    [:ok, router_conn: router_conn]
  end
  # rubocop:enable Style/HashSyntax, Style/LambdaCall

end
