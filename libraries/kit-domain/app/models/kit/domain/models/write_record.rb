class Kit::Domain::Models::WriteRecord < Kit::Domain::Models::EngineRecord

  include Kit::Domain::Models::Concerns::WriteRecord

  establish_connection :primary_write

end
