require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Or[Eq[1], Eq['1']]
  def self.test_or(a)
    [:ok]
  end
end

describe "OR type" do
  subject { TestModule.method(:test_or) }

  context 'with valid values' do
    let(:values) do
      [
        1,
        '1',
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
        2,
        { c: :ok, },
      ]
    end

    it 'fails' do
      values.each do |payload|
        expect { subject.call(payload) }.to raise_error(Kit::Contract::Error)
      end
    end
  end

end

