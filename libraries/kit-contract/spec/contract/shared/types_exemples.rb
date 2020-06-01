RSpec.shared_examples_for 'a contract that succeeds on valid values' do |local_contract = nil|

  it 'suceeds with valid values' do
    local_contract ||= contract

    args_valid.each do |args|
      status, _ctx = Kit::Contract::Services::Validation.valid?(contract: local_contract, args: args)
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

      error_msg ||= "IS_A failed: expected `#{ args[0].inspect }` of type `#{ args[0].class }` to be of type `#{ expected_type }`"

      expect(ctx[:errors].first[:detail]).to eq(error_msg)
    end
  end

end
