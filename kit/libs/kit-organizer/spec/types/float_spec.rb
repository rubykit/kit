require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Float
  def self.test_float(a)
    [:ok]
  end
end

describe "Float type" do
  subject { TestModule.method(:test_float) }

  context 'with valid values' do
    let(:values) do
      [
        0.0,
        1.0,
        Float::MAX,
        Float::MIN,
        Float::INFINITY,
        Float::EPSILON,
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

