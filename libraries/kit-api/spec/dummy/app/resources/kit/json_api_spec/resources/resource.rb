class Kit::JsonApiSpec::Resources::Resource < Kit::Api::Resources::ActiveRecordResource # rubocop:disable Style/Documentation

  def self.linker
    Kit::JsonApiSpec::Services::Linker.to_h
  end

end
