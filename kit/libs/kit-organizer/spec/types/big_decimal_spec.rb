require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before BigDecimal
  def self.test_big_decimal(a)
    [:ok]
  end
end

describe "BIG DECIMAL type" do
  subject { TestModule.method(:test_big_decimal) }

  context 'with valid values' do
    let(:values) do
      [
        BigDecimal(1),
      ]
    end

    it 'succeeds' do
      values.each do |payload|
        expect(subject.call(payload)).to eq [:ok]
      end
    end
  end

  context 'with invalid values' do
    let(:values) do
      [
        nil,
        1,
        1.0,
        ::Kernel::Rational(1),
      ]
    end

    it 'fails' do
      values.each do |payload|
        expect { subject.call(payload) }.to raise_error(Kit::Contract::Error)
      end
    end
  end

end

