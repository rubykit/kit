module Kit::Auth::Models
  class WriteRecord < EngineRecord
    include Kit::Domain::Models::Concerns::WriteRecord

    establish_connection :"#{Rails.env}_write"

  end
end
