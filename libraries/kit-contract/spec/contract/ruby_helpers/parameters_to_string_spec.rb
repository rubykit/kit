require_relative '../../rails_helper'
require_relative '../../../lib/kit/contract'

describe 'RubyHelpers' do

  context 'given a callable' do
    let(:service) { Kit::Contract::Services::RubyHelpers }

    tests = [
      {
        callable:       ->(n1, n2 = :value, *args, n3, k1: :value2, k2:, **opts, &block) { [:ok] }, # rubocop:disable Lint/UnusedBlockArgument
        parameters_str: '{ args: [n1, n2, *args, n3], kwargs: { k2: k2, k1: k1 }.merge(opts), block: block, }',
        signature_str:  'n1, n2 = nil, *args, n3, k2:, k1: nil, **opts, &block',
      },
      {
        callable:       ->(n1, n2 = :value, *, k1: :value2, k2:, **, &block) { [:ok] }, # rubocop:disable Lint/UnusedBlockArgument
        parameters_str: '{ args: [n1, n2, *_KC_REST], kwargs: { k2: k2, k1: k1 }.merge(_KC_KEYREST), block: block, }',
        signature_str:  'n1, n2 = nil, *_KC_REST, k2:, k1: nil, **_KC_KEYREST, &block',
      },
    ]

    it 'successfully generate the expected parameters string' do
      tests.each do |el|
        parameters = el[:callable].parameters
        string     = el[:parameters_str]

        expect(service.parameters_to_string_arguments(parameters: parameters)).to eq string
      end
    end

    it 'successfully generate the expected signature string' do
      tests.each do |el|
        parameters = el[:callable].parameters
        string     = el[:signature_str]

        expect(service.parameters_to_string_signature(parameters: parameters)).to eq string
      end
    end

  end

end
