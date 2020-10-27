module Kit::Auth::Models
  class ReadRecord < EngineRecord

    include Kit::Domain::Models::Concerns::ReadRecord

    establish_connection :primary_readonly

  end
end
