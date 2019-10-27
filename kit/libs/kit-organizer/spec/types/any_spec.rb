require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Hash[a: Any]
  def self.test_any(a:)
    [:ok]
  end
end

describe "ANY type" do
  subject { TestModule.method(:test_any) }

  context 'with valid values' do
    let(:values) do
      [
        { a: nil, },
        { a: 4, },
        { a: [2], },
        { a: { b: 2, }, },
        { a: 1..2, },
        { a: 'test', },
        { a: Object.new(), },
      ]
    end

    it 'succeeds' do
      values.each do |payload|
        expect(subject.call(payload)).to eq [:ok]
      end
    end
  end

end

