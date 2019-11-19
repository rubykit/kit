require_relative '../rails_helper'
require_relative '../../lib/kit/contract'
require_relative 'shared/signature_exemples'

module TestClasses
  module Organizer
    include Kit::Contract
    Ct = Kit::Contract::BuiltInContracts

    contract Ct::Hash[list: Ct::Array.of(Ct::Or[Ct::Callable, Ct::Symbol]), ctx: Ct::Optional[Ct::Hash], filter: Ct::Optional[Ct::Boolean]] => Kit::Organizer::Contracts::ResultTupple
    def self.organize(list:, ctx: nil, filter: nil, result:)
      result
    end

  end
end

describe TestClasses::Organizer do

  subject { described_class.method(:organize) }

  let(:args_valid) do
    {
      [{ list: [],                            ctx: { user_id: 1 }, result: [:ok], }] => [:ok],
      [{ list: [(->() {}), :callable_symbol], ctx: { user_id: 1 }, result: [:ok], }] => [:ok],

      [{ list: [], result: [:error], }]                 => [:error],
      [{ list: [], result: [:error, { errors: [] }], }] => [:error, { errors: [] }],
    }
  end

  it_behaves_like 'a signature contract that succeeds on valid values'

  let(:args_invalid) do
    {
      [{ list: [(->() {}), :callable_symbol], ctx: [], result: nil }] => 'Contract failure before `TestClasses::Organizer#organize`: ["IS_A failed: expected `[]` to be a `Hash`"]',
      [{ list: [(->() {}), 'a'], ctx: { user_id: 1 } , result: nil }] => 'Contract failure before `TestClasses::Organizer#organize`: ["OR failed"]',
      [{ list: :symbol, ctx: { user_id: 1 },           result: nil }] => 'Contract failure before `TestClasses::Organizer#organize`: ["IS_A failed: expected `symbol` to be a `Array`"]',

      [{ list: [], result: [:errors],    }] => 'Contract failure after `TestClasses::Organizer#organize`: ["OR failed"]',
      [{ list: [], result: [:error, []], }] => 'Contract failure after `TestClasses::Organizer#organize`: ["OR failed"]',
      [{ list: [], result: 2,            }] => 'Contract failure after `TestClasses::Organizer#organize`: ["OR failed"]',
    }
  end

  it_behaves_like 'a signature contract that fails on invalid values'

end