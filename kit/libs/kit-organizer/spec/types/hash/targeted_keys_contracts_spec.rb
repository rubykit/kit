require_relative '../../rails_helper'
require_relative '../../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Hash[a: Symbol, b: Symbol]
  def self.test_targetted(a:, b:)
    [:ok]
  end

  before Hash[a: Symbol, b: Symbol]
  def self.test_targetted_missing_keys(a:, **)
    [:ok]
  end

end

describe "HASH type" do

  context 'with targetted keys contracts' do
    subject { TestModule.method(:test_targetted) }

    context 'with valid values' do
      let(:values) do
        [
          { a: :a, b: :b },
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
          { a: :a, b: 'b' },
          { a: 'a', b: :b },
          { a: :a, b: nil },
          { a: nil, b: :b },
          { a: :a, b: 1 },
          { a: 1, b: :b },
        ]
      end

      it 'fails' do
        values.each do |payload|
          expect { subject.call(payload) }.to raise_error(Kit::Contract::Error)
        end
      end
    end

=begin
      context 'with missing key' do
        let(:subject)  { TestModule.method(:test_targetted_missing_keys) }
        let(:values) do
          [
            { a: :a, },
            { b: :b, },
          ]
        end

        it 'fails' do
          values.each do |payload|
            expect { subject.call(payload) }.to raise_error(Kit::Contract::Error)
          end
        end
      end
=end
  end

end
