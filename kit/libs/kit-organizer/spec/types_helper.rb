RSpec.shared_examples_for 'a contract that succeeds on valid values' do

  it 'suceeds with valid values' do
    args_valid.each do |args|
      status, ctx = Kit::Contract::Services::Validate.valid?(contract: contract, args: args)
      expect(status).to eq(:ok)
    end
  end

end


RSpec.shared_examples_for 'a contract that fails on invalid values' do

  it 'fails with invalid values' do
    args_invalid.each do |args, error_msg|
      status, ctx = Kit::Contract::Services::Validate.valid?(contract: contract, args: args)
      expect(status).to eq(:error)
      expect(ctx[:errors].first[:detail]).to eq(error_msg)
    end
  end

end
