RSpec.shared_examples_for 'a signature contract that succeeds on valid values' do

  it 'suceeds with valid values' do
    args_valid.each do |args, result|
      expect(subject.call(*args)).to eq result
    end
  end

end

RSpec.shared_examples_for 'a signature contract that fails on invalid values' do

  it 'fails with invalid values' do
    args_invalid.each do |args, error_msg|
      expect { subject.call(*args) }.to(
        raise_error(
          an_instance_of(Kit::Contract::Error).and(having_attributes(message: error_msg))
        )
      )
    end
  end

end
