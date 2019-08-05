module Kit::Domain::Models::Concerns
  module WriteRecord
    extend ActiveSupport::Concern

    included do
      self.abstract_class = true
    end

    class_methods do

      def to_read_class
        self.name.gsub('::Write::', '::Read::').constantize rescue nil
      end

      def to_write_class
        self
      end

      def is_read_class?
        false
      end

      def is_write_class?
        true
      end

    end

    def to_read_record
      self.class.to_read_class&.find_by(id: self.id)
    end

    def to_write_record
      self
    end

  end
end