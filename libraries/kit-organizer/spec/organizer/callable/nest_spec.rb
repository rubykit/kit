require_relative '../../rails_helper'
require_relative '../../../lib/kit/organizer'

describe Kit::Organizer::Services::Callable::Nest do

  let(:inc_a) { ->(a:) { [:ok, a: a + 1] } }
  let(:inc_b) { ->(b:) { [:ok, b: b + 1] } }
  let(:inc_c) { ->(c:) { [:ok, c: c + 1] } }

  let(:ctx_in) { { a: 0, b: 0, c: 0 } }

  let(:payload) do
    [:nest, {
      ok:    [
        inc_a,
        ->(b:) { [:error, b: b + 1] },
        inc_c,
      ],
      error: [
        inc_b,
      ],
    },]
  end

  describe '.resolve' do
    subject { described_class.resolve(args: payload) }

    let(:ctx_out) { { a: 1, b: 2, c: 0 } }

    it 'returns the expected wrapped callable' do
      status, ctx = subject
      expect(status).to eq(:ok)
      expect(ctx[:callable].call(**ctx_in)).to eq([:ok, ctx_out])
    end
  end

  describe 'Kit::Organizer flow' do
    let(:ctx_out) { { a: 3, b: 2, c: 0 } }

    it 'continues execution properly' do
      status, ctx = Kit::Organizer.call(
        ok:  [
          inc_a,
          payload,
          inc_a,
        ],
        ctx: ctx_in,
      )

      expect(status).to be :ok
      expect(ctx).to eq(ctx_out)
    end
  end

end
