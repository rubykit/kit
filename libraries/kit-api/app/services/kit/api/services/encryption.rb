require 'openssl'
require 'URLcrypt'
require 'oj'

# Symmetric 256-bit AES encryption for strings.
#
# Wrapper around URLcrypt methods, with explicit `key`.
#
# ## References
# - https://github.com/cheerful/URLcrypt
# - https://github.com/cheerful/URLcrypt/blob/master/lib/URLcrypt.rb
#
module Kit::Api::Services::Encryption

  # Size of a valid key for AES-256
  MIN_KEY_SIZE = 32

  # Encrypt `data` using `key`.
  def self.encrypt(data:, key:)
    return Kit::Error('Invalid data to encrypt.') if !data || data.size == 0
    return Kit::Error('Invalid encryption key.')  if (key&.size || 0) < MIN_KEY_SIZE

    data = Oj.dump(data)
    begin
      cipher = generate_cipher(mode: :encrypt, key: key)
    rescue ArgumentError # Just in case
      return Kit::Error('Invalid encryption key.')
    end
    cipher.iv = iv = cipher.random_iv
    encrypted_data = "#{ URLcrypt.encode(iv) }Z#{ URLcrypt.encode(cipher.update(data) + cipher.final) }"

    [:ok, encrypted_data: encrypted_data]
  end

  # Decrypt `encrypted_data` using `key`.
  def self.decrypt(encrypted_data:, key:)
    iv, encrypted_payload = encrypted_data&.split('Z')&.map { |part| URLcrypt.decode(part) }

    return Kit::Error('Invalid string to decrypt.') if !iv || !encrypted_payload
    return Kit::Error('Invalid encryption key.')    if (key&.size || 0) < MIN_KEY_SIZE

    cipher    = generate_cipher(mode: :decrypt, key: key)
    cipher.iv = iv
    data      = cipher.update(encrypted_payload) + cipher.final
    data      = Oj.load(data)

    [:ok, data: data]
  rescue OpenSSL::Cipher::CipherError, Oj::ParseError
    return Kit::Error('Invalid string to decrypt.')
  end

  # Generate an OpenSSL cipher.
  def self.generate_cipher(mode:, key:)
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.send(mode)
    cipher.key = key.byteslice(0, cipher.key_len)
    cipher
  end

end
