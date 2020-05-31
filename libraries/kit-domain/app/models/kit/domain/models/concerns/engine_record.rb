# Namespace for various Concerns.
module Kit::Domain::Models::Concerns
end

# Mixin for any Domain Record.
module Kit::Domain::Models::Concerns::EngineRecord

  extend ActiveSupport::Concern

  included do
    self.abstract_class = true

    class_attribute :columns_whitelisting
    self.columns_whitelisting = true
  end

  class_methods do

    # Removes Engine modules name
    def table_name
      super.demodulize.tableize
    end

  end

  # Ex: User#1
  def model_log_name
    "#{ self.class.model_name.element.camelize }##{ self.id }"
  end

  # Ex: User#1|dev@test.com
  def model_verbose_name
    "#{ self.class.model_name.element.camelize }##{ self.id }"
  end

  def read_record?
    self.class.read_class?
  end

  def write_record?
    self.class.write_class?
  end

  def readonly?
    self.class.read_class?
  end

end
