require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Hash[a: Numeric]
  def self.test_numeric(a:)
    [:ok]
  end
end

describe "Numeric type" do
  subject { TestModule.method(:test_numeric) }

  context 'with valid values' do
    let(:values) do
      [
        { a: 1, },
        { a: 1.0, },
        { a: ::Kernel::Integer(1), },
        { a: ::Kernel::Float(1), },
        { a: ::Kernel::Rational(1), },
        { a: ::Kernel::Complex(1), },
        { a: ::BigDecimal.new(1), },
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
        { a: nil, },
        { a: '1', },
      ]
    end

    it 'fails' do
      values.each do |payload|
        expect { subject.call(payload) }.to raise_error(Kit::Contract::Error)
      end
    end
  end

end

