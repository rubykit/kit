module Kit::Domain::Models
  class ReadRecord < EngineRecord
    include Kit::Domain::Models::Concerns::ReadRecord

    establish_connection :"#{Rails.env}_readonly"

  end
end
