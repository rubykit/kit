require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Hash[a: Symbol]
  def self.test_symbol(a:)
    [:ok]
  end
end

describe "SYMBOL type" do
  subject { TestModule.method(:test_symbol) }

  context 'with valid values' do
    let(:values) do
      [
        { a: :a },
        { a: :"1" },
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
        { a: 'a' },
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

