module Kit::Domain::Models
  class EngineRecord < ActiveRecord::Base
    self.abstract_class = true

    include Kit::Domain::Models::Concerns::EngineRecord

  end
end
