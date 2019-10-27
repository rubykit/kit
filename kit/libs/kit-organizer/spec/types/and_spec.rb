require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Hash[a: And[->(v) { v && v > 3 }, ->(v) { v && v < 5 }]]
  def self.test_and(a:)
    [:ok]
  end
end

describe "AND type" do
  subject { TestModule.method(:test_and) }

  context 'with valid values' do
    let(:values) do
      [
        { a: 4 },
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
        { a: 3 },
        { a: 5 },
      ]
    end

    it 'fails' do
      values.each do |payload|
        expect { subject.call(payload) }.to raise_error(Kit::Contract::Error)
      end
    end
  end

end

