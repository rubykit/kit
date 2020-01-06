require_relative '../../rails_helper'
require_relative '../../../lib/kit/organizer'

describe Kit::Organizer::Services::Callable::Method do

  module TestModules
    module CallableMethod
      def self.m1(b:, c: {})
        [:ok, b.merge(c)]
      end
    end
  end

  describe '.resolve' do
    subject { described_class.resolve(args: payload) }

    let(:object_instance) { TestModules::CallableMethod }
    let(:method_name)     { :m1 }

    let(:payload)         { [:method, object_instance, method_name] }

    it 'returns a wrapped callable of the target' do
      status, ctx = subject
      expect(status).to         eq(:ok)
      expect(ctx[:callable]).to eq(object_instance.method(method_name))
    end

  end

end
