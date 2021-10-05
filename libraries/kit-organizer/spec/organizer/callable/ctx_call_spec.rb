require_relative '../../rails_helper'
require_relative '../../../lib/kit/organizer'

describe Kit::Organizer::Services::Callable::CtxCall do

  describe 'Kit::Organizer flow' do

    let(:callable_key) { :custom_callable }
    let(:callable) do
      ->(a:) { [:ok, b: a + 1] }
    end

    let(:ok_list) do
      [
        [:ctx_call, callable_key],
        ->(b:) { [:ok, c: b + 1] },
      ]
    end

    it 'calls the context callable' do
      status, ctx = Kit::Organizer.call(
        ok:  ok_list,
        ctx: {
          a:              0,
          callable_key => callable,
        },
      )

      expect(status).to be :ok
      expect(ctx.except(:custom_callable)).to eq({ a: 0, b: 1, c: 2 })
    end

  end

end
