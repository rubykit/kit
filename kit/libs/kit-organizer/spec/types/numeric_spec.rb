require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Numeric
  def self.test_numeric(a)
    [:ok]
  end
end

describe "Numeric type" do
  subject { TestModule.method(:test_numeric) }

  context 'with valid values' do
    let(:values) do
      [
        1,
        1.0,
        ::Kernel::Integer(1),
        ::Kernel::Float(1),
        ::Kernel::Rational(1),
        ::Kernel::Complex(1),
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
        '1',
      ]
    end

    it 'fails' do
      values.each do |payload|
        expect { subject.call(payload) }.to raise_error(Kit::Contract::Error)
      end
    end
  end

end

