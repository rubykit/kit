require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Hash[a: Rational]
  def self.test_rational(a:)
    [:ok]
  end
end

describe "BIG DECIMAL type" do
  subject { TestModule.method(:test_big_decimal) }

  context 'with valid values' do
    let(:values) do
      [
        { a: ::Kernel::Rational(1), },
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
        { a: 1, },
        { a: 1.0, },
        { a: ::Kernel::Complex(1), },
      ]
    end

    it 'fails' do
      values.each do |payload|
        expect { subject.call(payload) }.to raise_error(Kit::Contract::Error)
      end
    end
  end

end

