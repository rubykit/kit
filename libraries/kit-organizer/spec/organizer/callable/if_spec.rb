require_relative '../../rails_helper'
require_relative '../../../lib/kit/organizer'

describe Kit::Organizer::Services::Callable::If do

  describe '.resolve' do
    subject do
      status, ctx = described_class.resolve(args: payload)
      expect(status).to eq(:ok)
      ctx[:callable]
    end

    let(:payload) do
      [:if, callable_predicate, {
        ok:    [
          ->(a:) { [:ok, a: a + 1] },
        ],
        error: [
          ->(b:) { [:ok, b: b + 1] },
        ],
      },]
    end

    let(:predicate_ok)    { ->(a:) { [:ok,    a: a + 1] } }
    let(:predicate_error) { ->(b:) { [:error, b: b + 1] } }

    context 'when predicate returns :ok' do
      let(:callable_predicate) { predicate_ok }

      it 'calls the :ok branch' do
        callable = subject
        result   = callable.call(a: 0, b: 0)

        expect(result).to eq([:ok, { a: 2, b: 0 }])
      end
    end

    context 'when predicate returns :error' do
      let(:callable_predicate) { predicate_error }

      it 'calls the :error branch' do
        callable = subject
        result   = callable.call(a: 0, b: 0)

        expect(result).to eq([:ok, { a: 0, b: 2 }])
      end
    end

  end

end
