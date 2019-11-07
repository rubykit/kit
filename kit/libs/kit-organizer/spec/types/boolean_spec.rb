require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Boolean
  def self.test_boolean(a)
    [:ok]
  end
end

describe "BOOLEAN type" do
  subject { TestModule.method(:test_boolean) }

  context 'with valid values' do
    let(:values) do
      [
        true,
        false,
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

