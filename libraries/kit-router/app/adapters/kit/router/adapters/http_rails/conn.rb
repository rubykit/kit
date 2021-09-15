# Conn helpers.
module Kit::Router::Adapters::HttpRails::Conn

  def self.cookies_encrypted_prefix
    '__enc_'
  end

  def self.cookies_signed_prefix
    '__sig_'
  end

end
