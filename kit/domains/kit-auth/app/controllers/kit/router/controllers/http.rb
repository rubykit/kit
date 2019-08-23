module Kit::Router::Controllers
  module Http

    # LINK: https://en.wikipedia.org/wiki/HTTP_302
    def self.redirect_to(location:, status: 302, domain: nil, notice: nil, alert: nil)
      status = 302 if status.blank?

      [:ok_stop, {
        metadata: {
          http: {
            status: status,
            redirect: {
              location: location,
              domain:   domain,
              notice:   notice,
              alert:    alert,
            }
          }
        },
      }]
    end

  end
end
