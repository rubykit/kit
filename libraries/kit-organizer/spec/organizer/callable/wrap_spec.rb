require_relative '../../rails_helper'
require_relative '../../../lib/kit/organizer'

describe Kit::Organizer::Services::Callable::Wrap do

  describe '.resolve' do
    subject { described_class.resolve(args: payload) }

    let(:payload) do
      [:wrap, callable, in: { a: :b }, out: { c: :d }]
    end

    let(:callable) { ->(b:) { [:ok, { c: b + 1  }] } }
    let(:wrapped_callable) { subject }

    it 'returns the expected wrapped callable' do
      status, ctx = subject
      expect(status).to eq(:ok)
      expect(ctx[:callable].call(a: 1)).to eq([:ok, d: 2])
    end
  end

end
