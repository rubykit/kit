class Kit::Auth::Resources::Api::Resource < Kit::Api::Resources::ActiveRecordResource # rubocop:disable Style/Documentation

  def self.linker
    Kit::Auth::Services::Api::Linker.to_h
  end

end
