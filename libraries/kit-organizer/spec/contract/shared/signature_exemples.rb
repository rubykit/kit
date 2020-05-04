RSpec.shared_examples_for 'a signature contract that succeeds on valid values' do |callable = nil|

  it 'suceeds with valid values' do
    callable ||= subject

    args_valid.each do |args, result|
      expect(callable.call(*args)).to eq result
    end
  end

end

RSpec.shared_examples_for 'a signature contract that fails on invalid values' do |callable = nil|

  it 'fails with invalid values' do
    callable ||= subject

    args_invalid.each do |args, error_msg|
      if error_msg.is_a?(Array)
        exception_class, error_msg = error_msg
      else
        exception_class = Kit::Contract::Error
      end

      expect { callable.call(*args) }.to(
        raise_error(
          an_instance_of(exception_class).and(having_attributes(message: a_string_starting_with(error_msg)))
        )
      )
    end
  end

end
