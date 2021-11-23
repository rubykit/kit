require_relative '../../rails_helper'
require_relative '../../../lib/kit/organizer'

describe Kit::Organizer::Services::Callable::Branch do

  describe '.resolve' do
    subject do
      status, ctx = described_class.resolve(args: payload)
      expect(status).to eq(:ok)
      ctx[:callable]
    end

    let(:branch_callable) { -> { branch_name } }

    let(:payload) do
      [:branch, branch_callable, {
        br_a: [
          ->(a:) { [:ok, a: a + 1] },
        ],
        br_b: [
          ->(b:) { [:ok, b: b + 1] },
        ],
      },]
    end

    {
      br_a: { a: 1, b: 0 },
      br_b: { a: 0, b: 1 },
    }.each do |tmp_branch_name, tmp_result|
      context "when predicate returns #{ tmp_branch_name }" do
        let(:branch_name) { tmp_branch_name }
        let(:result_ctx)  { tmp_result }

        it 'calls the expected branch' do
          callable = subject
          result   = callable.call(a: 0, b: 0)

          expect(result).to eq([:ok, result_ctx])
        end
      end
    end

  end

end
