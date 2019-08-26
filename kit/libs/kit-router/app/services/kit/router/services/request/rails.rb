module Kit::Router::Services::Request
  module Rails

    def self.cookies_encrypted_prefix
      'enc|'
    end

    def self.cookies_signed_prefix
      'sig|'
    end

  end
end