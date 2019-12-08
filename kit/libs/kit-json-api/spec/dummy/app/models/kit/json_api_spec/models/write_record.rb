class Kit::JsonApiSpec::Models::WriteRecord < Kit::JsonApiSpec::Models::EngineRecord
  include Kit::Domain::Models::Concerns::WriteRecord

  establish_connection :"primary_write"
end
