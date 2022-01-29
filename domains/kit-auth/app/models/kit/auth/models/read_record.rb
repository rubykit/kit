class Kit::Auth::Models::ReadRecord < Kit::Auth::Models::EngineRecord

  include Kit::Domain::Models::Concerns::ReadRecord

  establish_connection :primary_readonly

end
