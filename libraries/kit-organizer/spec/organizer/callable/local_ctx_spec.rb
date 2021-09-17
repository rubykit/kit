require_relative '../../rails_helper'
require_relative '../../../lib/kit/organizer'

describe Kit::Organizer::Services::Callable::LocalCtx do

  describe '.resolve' do
    subject { described_class.resolve(args: payload) }

    let(:payload) do
      [:local_ctx, callable, { b: 2 }]
    end

    let(:callable) do
      ->(a:, b:) { [:ok, a: a + b] }
    end

    let(:wrapped_callable) { subject }

    it 'returns a wrapped callable' do
      status, ctx = subject
      expect(status).to eq(:ok)
      expect(ctx[:callable].call(a: 1)).to eq([:ok, a: 3])
    end
  end

end
