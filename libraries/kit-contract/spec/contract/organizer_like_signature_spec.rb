require_relative '../rails_helper'
require_relative '../../lib/kit/contract'
require_relative 'shared/signature_exemples'

# Namespace for test dummy modules.
module TestModules
end

# Dummy module.
module TestModules::Organizer

  include Kit::Contract::Mixin
  Ct = Kit::Contract::BuiltInContracts

  contract Ct::Hash[list: Ct::Array.of(Ct::Or[Ct::Callable, Ct::Symbol]), ctx: Ct::Optional[Ct::Hash], filter: Ct::Optional[Ct::Boolean]] => Kit::Organizer::Contracts::ResultTupple
  def self.organize(list:, result:, ctx: nil, filter: nil)
    result
  end

end

describe TestModules::Organizer do

  subject { described_class.method(:organize) }

  let(:args_valid) do
    {
      { kwargs: { list: [],                          ctx: { user_id: 1 }, result: [:ok] } } => [:ok],
      { kwargs: { list: [(-> {}), :callable_symbol], ctx: { user_id: 1 }, result: [:ok] } } => [:ok],

      { kwargs: { list: [], result: [:error] } }                                            => [:error],
      { kwargs: { list: [], result: [:error, { errors: [] }] } }                            => [:error, { errors: [] }],
    }
  end

  it_behaves_like 'a signature contract that succeeds on valid values'

  let(:args_invalid) do
    {
      { kwargs: { list: [(-> {}), :callable_symbol], ctx: [], result: nil } }   => 'Contract failure before `TestModules::Organizer#organize`: ["IS_A failed:',
      { kwargs: { list: [(-> {}), 'a'], ctx: { user_id: 1 }, result: nil } }    => 'Contract failure before `TestModules::Organizer#organize`: ["OR failed',
      { kwargs: { list: :symbol, ctx: { user_id: 1 },           result: nil } } => 'Contract failure before `TestModules::Organizer#organize`: ["IS_A failed:',

      { kwargs: { list: [], result: [:errors]    } }                            => 'Contract failure after `TestModules::Organizer#organize`: ["OR failed',
      { kwargs: { list: [], result: [:error, []] } }                            => 'Contract failure after `TestModules::Organizer#organize`: ["OR failed',
      { kwargs: { list: [], result: 2            } }                            => 'Contract failure after `TestModules::Organizer#organize`: ["OR failed',
    }
  end

  it_behaves_like 'a signature contract that fails on invalid values'

end
