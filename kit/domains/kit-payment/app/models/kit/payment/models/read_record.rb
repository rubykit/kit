module Kit::Payment::Models
  class ReadRecord < EngineRecord
    include Kit::Domain::Models::Concerns::ReadRecord

    establish_connection :"#{Rails.env}_readonly"

  end
end
