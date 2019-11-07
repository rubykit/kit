require_relative '../rails_helper'
require_relative '../../lib/kit/contract'

module TestModule
  include Kit::Contract
  include Kit::Contract::Types

  before Callable
  def self.test_callable(a)
    [:ok]
  end

  def self.callable_method()
    true
  end

  class Functor
    def call()
      true
    end
  end

end

describe "CALLABLE type" do
  subject { TestModule.method(:test_callable) }

  context 'with valid values' do
    let(:values) do
      [
        ->(v) { true },
        TestModule.method(:callable_method),
        TestModule::Functor.new,
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
        3,
      ]
    end

    it 'fails' do
      values.each do |payload|
        expect { subject.call(payload) }.to raise_error(Kit::Contract::Error)
      end
    end
  end

end

