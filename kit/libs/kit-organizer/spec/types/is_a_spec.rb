require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Hash[a: IsA[::String]]
  def self.test_is_a(a:)
    [:ok]
  end
end

describe "IS A type" do
  subject { TestModule.method(:test_is_a) }

  context 'with valid values' do
    let(:values) do
      [
        { a: 'a', },
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
        { a: { c: :ok, }, },
      ]
    end

    it 'fails' do
      values.each do |payload|
        expect { subject.call(payload) }.to raise_error(Kit::Contract::Error)
      end
    end
  end

end

