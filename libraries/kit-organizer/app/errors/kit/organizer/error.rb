# When using contracts on method signatures (through `before`, `after`, `contract`),
#   a `Kit::Contract::Error` exception is raised when a contract failure happens.
class Kit::Organizer::Error < ::StandardError

  def initialize(msg) # rubocop:disable Lint/UselessMethodDefinition
    super
  end

end
