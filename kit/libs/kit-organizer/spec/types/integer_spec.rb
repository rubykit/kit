require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Integer
  def self.test_integer(a)
    [:ok]
  end
end

describe "INTEGER type" do
  subject { TestModule.method(:test_integer) }

  context 'with valid values' do
    let(:values) do
      [
        1,
        9000000000000000000000000000,
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

