require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Eq[1]
  def self.singleton_test_eq(a)
    [:ok]
  end

end

describe "EQ type" do

  context 'singleton method contract' do
    subject { TestModule.method(:singleton_test_eq) }

    context 'with valid values' do
      let(:values) do
        [
          1,
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
          '1',
          2,
          { c: :ok },
        ]
      end

      it 'fails' do
        values.each do |payload|
          expect { subject.call(payload) }.to raise_error(Kit::Contract::Error)
        end
      end
    end
  end

end