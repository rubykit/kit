require_relative '../rails_helper'
require_relative '../../lib/kit/contract'
require_relative 'shared/signature_exemples'

CtA = Kit::Contract::BuiltInContracts::Hash[
  kA: Kit::Contract::BuiltInContracts::Delayed[-> { CtA }],
  kB: Kit::Contract::BuiltInContracts::Eq[true],
]

context 'in a circular reference scenario' do

  let(:subject) do
    Kit::Contract::Services::Validation.valid?(contract: contract, parameters: parameters)
  end

  let(:contract) { CtA }
  let(:parameters) do
    hash = { kA: nil, kB: should_succeed }
    hash[:kA] = hash

    { kwargs: hash }
  end

  context 'in unsafe mode' do
    let(:should_succeed) { true }
    before { Kit::Contract::BuiltInContracts::Hash.disable_safe_nesting = true  }
    after  { Kit::Contract::BuiltInContracts::Hash.disable_safe_nesting = false }

    it 'triggers an infinite loop no create an infinite loop' do
      expect { subject }.to raise_error(SystemStackError)
    end
  end

  context 'in safe mode, infinite loop is avoided' do
    let(:safe) { true }

    context 'with valid args' do
      let(:should_succeed) { true }

      it 'passes' do
        status, _ctx = subject
        expect(status).to eq :ok
      end
    end

    context 'with invalid args' do
      let(:should_succeed) { false }

      it 'errors out' do
        status, _ctx = subject
        expect(status).to eq :error
      end
    end

  end

end
