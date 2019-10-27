require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Hash[a: String]
  def self.test_string(a:)
    [:ok]
  end
end

describe "STRING type" do
  subject { TestModule.method(:test_string) }

  context 'with valid values' do
    let(:values) do
      [
        { a: "a", },
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
        { a: :a, },
        { a: 1, },
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

