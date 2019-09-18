module Kit::Router::Services::Adapters::Http::Rails
  module Request

    def self.cookies_encrypted_prefix
      'enc|'
    end

    def self.cookies_signed_prefix
      'sig|'
    end

  end
end