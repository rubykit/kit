module Kit::JsonApiSpec::Endpoints # rubocop:disable Style/Documentation

  def self.register_endpoints
    Kit::JsonApiSpec::Endpoints::Create.register_endpoints
    Kit::JsonApiSpec::Endpoints::Delete.register_endpoints
    Kit::JsonApiSpec::Endpoints::Index.register_endpoints
    Kit::JsonApiSpec::Endpoints::Show.register_endpoints
    Kit::JsonApiSpec::Endpoints::Update.register_endpoints
  end

end
