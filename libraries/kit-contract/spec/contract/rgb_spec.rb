require_relative '../rails_helper'
require_relative '../../lib/kit/contract'
require_relative 'shared/signature_exemples'

# Namespace for test dummy modules.
module TestModules
end

# Dummy module.
module TestModules::RGB

  include Kit::Contract::Mixin

  before ->(r:, g:, b:) { (0..255) === r && (0..255) === g && (0..255) === b } # rubocop:disable Style/CaseEquality
  after  [
    ->(result) { result.is_a?(String) },
    ->(result) { result.start_with?('#') },
    ->(result) do
      if result.start_with?('#')
        [:ok]
      else
        [:error, 'The result should start with a `#` sign']
      end
    end,
    ->(result) { result.length.in?([4, 7]) },
  ]
  def self.rgb_to_hex(r:, g:, b:) # rubocop:disable Naming/MethodParameterName
    '#' << [r, g, b].map { |el| el.to_s(16).rjust(2, '0') }.join.upcase
  end

end

describe TestModules::RGB do

  subject { described_class.method(:rgb_to_hex) }

  let(:args_valid) do
    {
      { kwargs: { r: 128, g: 32, b: 12 } } => '#80200C',
    }
  end

  it_behaves_like 'a signature contract that succeeds on valid values'

end
