class Kit::JsonApiSpec::Models::ReadRecord < Kit::JsonApiSpec::Models::EngineRecord # rubocop:disable Style/Documentation

  include Kit::Domain::Models::Concerns::ReadRecord

  establish_connection :primary_readonly

end
