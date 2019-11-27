require_relative '../../rails_helper'

describe Kit::Store::Contracts::CallableWithHash do

  let(:contract) { described_class[:a, :b] }
  let(:args_valid) do
    [
      [->(a:, b:) {}],
      [->(a:, **) {}],
      [->(b:, **) {}],
      [->(**)     {}],
    ]
  end
  let(:args_invalid) do
    {
      [nil]       => 'CALLABLE_WITH_HASH failed: object does not respond_to `call`',
      [->(b:) {}] => 'CALLABLE_WITH_HASH failed: callable does not accept the following keys: `[:a]`',
    }
  end

  it 'suceeds with valid values' do
    args_valid.each do |args|
      status, ctx = Kit::Contract::Services::Validation.valid?(contract: contract, args: args)
      expect(status).to eq(:ok)
    end
  end

  it 'fails with invalid values' do
    args_invalid.each do |args, error_msg|
      status, ctx = Kit::Contract::Services::Validation.valid?(contract: contract, args: args)
      expect(status).to eq(:error)
      expect(ctx[:errors].first[:detail]).to eq(error_msg)
    end
  end

end
