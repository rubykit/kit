class Kit::Events::Models::WriteRecord < Kit::Events::Models::EngineRecord

  include Kit::Domain::Models::Concerns::WriteRecord

  establish_connection :primary_write

end
