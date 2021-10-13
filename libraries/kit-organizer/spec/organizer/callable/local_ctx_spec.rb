require_relative '../../rails_helper'
require_relative '../../../lib/kit/organizer'

describe Kit::Organizer::Services::Callable::LocalCtx do

  let(:callable) do
    ->(a:, b:) { [:ok, a: a + b] }
  end

  let(:payload) do
    [:local_ctx, callable, { b: 2 }]
  end

  let(:ctx_in) do
    { a: 1 }
  end

  let(:ctx_out) do
    { a: 3 }
  end

  describe '.resolve' do
    subject { described_class.resolve(args: payload) }

    it 'returns a wrapped callable' do
      status, ctx = subject
      expect(status).to eq(:ok)
      expect(ctx[:callable].call(**ctx_in)).to eq([:ok, ctx_out])
    end
  end

  describe 'Kit::Organizer flow' do
    it 'does not leak the local context into the general context' do
      status, ctx = Kit::Organizer.call(
        ok:  [
          payload,
        ],
        ctx: ctx_in,
      )

      expect(status).to be :ok
      expect(ctx).to eq(ctx_out)
    end
  end

end
