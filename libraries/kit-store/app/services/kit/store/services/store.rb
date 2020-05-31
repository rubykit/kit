# Namespace for Store related logic.
module Kit::Store::Services::Store

  def self.create
    Kit::Store::Types::Store[{
      tables: {},
    }]
  end

end
