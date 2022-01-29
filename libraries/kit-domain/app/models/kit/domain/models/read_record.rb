class Kit::Domain::Models:: ReadRecord < Kit::Domain::Models::EngineRecord

  include Kit::Domain::Models::Concerns::ReadRecord

  establish_connection :primary_readonly

end
