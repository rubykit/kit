require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before TrueClass
  def self.test_true_class(a)
    [:ok]
  end
end

describe "TRUE CLASS type" do
  subject { TestModule.method(:test_true_class) }

  context 'with valid values' do
    let(:values) do
      [
        true,
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
        false,
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

