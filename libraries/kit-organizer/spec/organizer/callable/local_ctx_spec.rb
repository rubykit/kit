require_relative '../../rails_helper'
require_relative '../../../lib/kit/organizer'

describe Kit::Organizer::Services::Callable::LocalCtx do

  let(:callable) do
    ->(a:, b:, c:) { [:ok, a: a + b + c] }
  end

  let(:payload) do
    [:local_ctx, callable, { b: 2 }, { c: :d }]
  end

  let(:ctx_in) do
    { a: 1, d: 4 }
  end

  let(:ctx_out) do
    { a: 7, d: 4 }
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

    context 'with both static & dynamic args provided' do

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

    context 'with only static arguments provided' do

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

      it 'works ' do
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

    context 'with only dynamic arguments provided' do

      let(:callable) do
        ->(a:, c:) { [:ok, a: a + c] }
      end

      let(:payload) do
        [:local_ctx, callable, nil, { c: :d }]
      end

      let(:ctx_in) do
        { a: 1, d: 4 }
      end

      let(:ctx_out) do
        { a: 5, d: 4 }
      end

      it 'works ' do
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

end
