module Kit::Auth::Models
  class WriteRecord < EngineRecord

    include Kit::Domain::Models::Concerns::WriteRecord

    establish_connection :primary_write

  end
end
