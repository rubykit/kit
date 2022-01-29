class Kit::Auth::Models::WriteRecord < Kit::Auth::Models::EngineRecord

  include Kit::Domain::Models::Concerns::WriteRecord

  establish_connection :primary_write

end
