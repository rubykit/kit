require_relative 'rails_helper'
require_relative '../lib/kit/contract'
require_relative 'signature_helper'

module TestModule
  include Kit::Contract

  before ->(**h) { h.has_key?(:b) }
  def self.test_before_callable(a:, **)
    [:ok]
  end

  before [->(h) { h.is_a?(::Hash) }, ->(h) { h[:a] == 2 },]
  def self.test_before_array(a:)
    [:ok]
  end

end

describe "before" do

  context 'with a single contract' do
    subject { TestModule.method(:test_before_callable) }

    let(:args_valid) do
      {
        [{ a: 2, b: 3 }] => [:ok],
      }
    end

    it_behaves_like 'a signature contract that succeeds on valid values'

    let(:args_invalid) do
      {
        [{ a: 2, }] => "Contract failure before `TestModule#test_before_callable`"
      }
    end

    it_behaves_like 'a signature contract that fails on invalid values'
  end

end
