class Kit::Events::Models::ReadRecord < Kit::Events::Models::EngineRecord

  include Kit::Domain::Models::Concerns::ReadRecord

  establish_connection :primary_readonly

end
