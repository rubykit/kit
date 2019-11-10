RSpec.shared_examples_for 'a contract that succeeds on valid values' do |local_contract = nil|

  it 'suceeds with valid values' do
    local_contract ||= contract

    args_valid.each do |args|
      status, ctx = Kit::Contract::Services::Validation.valid?(contract: local_contract, args: args)
      expect(status).to eq(:ok)
    end
  end

end

RSpec.shared_examples_for 'a contract that fails on invalid values' do |local_contract = nil|

  it 'fails with invalid values' do
    local_contract ||= contract

    args_invalid.each do |args, error_msg|
      status, ctx = Kit::Contract::Services::Validation.valid?(contract: local_contract, args: args)
      expect(status).to eq(:error)
      expect(ctx[:errors].first[:detail]).to eq(error_msg)
    end
  end

end
