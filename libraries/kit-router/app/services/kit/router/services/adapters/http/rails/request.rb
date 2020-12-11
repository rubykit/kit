module Kit::Router::Services::Adapters::Http::Rails

  # Request helpers.
  module Request

    def self.cookies_encrypted_prefix
      '__enc_'
    end

    def self.cookies_signed_prefix
      '__sig_'
    end

  end

end
