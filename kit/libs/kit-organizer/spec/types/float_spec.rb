require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Hash[a: Float]
  def self.test_float(a:)
    [:ok]
  end
end

describe "Float type" do
  subject { TestModule.method(:test_float) }

  context 'with valid values' do
    let(:values) do
      [
        { a: 0.0 },
        { a: 1.0 },
        { a: Float::MAX },
        { a: Float::MIN },
        { a: Float::INFINITY },
        { a: Float::EPSILON },
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
        { a: nil },
        { a: 1 },
        { a: '1' },
      ]
    end

    it 'fails' do
      values.each do |payload|
        expect { subject.call(payload) }.to raise_error(Kit::Contract::Error)
      end
    end
  end

end

