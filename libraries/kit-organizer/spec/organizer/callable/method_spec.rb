require_relative '../../rails_helper'
require_relative '../../../lib/kit/organizer'

# Namespace for test dummy modules.
module TestModules
end

# Dummy module.
module TestModules::CallableMethod

  def self.m1(b:, c: {}) # rubocop:disable Naming/MethodParameterName
    [:ok, b.merge(c)]
  end

end

describe Kit::Organizer::Services::Callable::Method do

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
