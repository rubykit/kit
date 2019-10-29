module Kit::Organizer::Services
  module Signature

    contract Hash[method: Callable, args: Array] => Boolean
    def self.can_receive?(callable:, args:)
      parameters = callable.parameters

      true
    end

    # Create a "transform payload" that succeeds if we can find a match

  end
end