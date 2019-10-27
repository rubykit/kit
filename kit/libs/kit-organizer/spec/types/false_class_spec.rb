require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Hash[a: FalseClass]
  def self.test_false_class(a:)
    [:ok]
  end
end

describe "FALSE CLASS type" do
  subject { TestModule.method(:test_false_class) }

  context 'with valid values' do
    let(:values) do
      [
        { a: false },
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
        { a: true },
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

