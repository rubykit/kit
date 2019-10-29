require_relative '../../rails_helper'
require_relative '../../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Hash.instance(->(el) { el.size == 2 })
  def self.test_instance_valid(a:, b:)
    [:ok]
  end

  before Hash.instance(->(h) { h.size == 2 })
  def self.test_instance_invalid(a:, b:, c:)
    [:ok]
  end

end

describe "HASH type" do

  context 'with instance contracts' do

    context 'with valid values' do
      subject { TestModule.method(:test_instance_valid) }

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

    context 'with valid values' do
      subject { TestModule.method(:test_instance_invalid) }

      let(:values) do
        [
          { a: :a, b: :b, c: :c },
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

