require_relative 'rails_helper'
require_relative '../lib/kit/contract'

describe "SignatureMatcher" do

  context 'given some arguments and a callable signature' do
    let(:service) { Kit::Contract::Services::SignatureMatcher }

    test_block = Proc.new {}

    tests = [
      {
        callable: ->(k1:, k2:) { [:ok] },
        list: {
          [{ k1: 1, k2: 2, k3: 3, }] => [{ k1: 1, k2: 2, }],
        },
      },
      {
        callable: ->(**keyrest) { [:ok] },
        list: {
          [{ k1: 1, k2: 2, k3: 3, }] => [{ k1: 1, k2: 2, k3: 3, }],
        },
      },
      {
        callable: ->(k1:, k2:, **keyrest) { [:ok] },
        list: {
          [{ k1: 1, k2: 2, k3: 3, }] => [{ k1: 1, k2: 2, }, { k3: 3, }],
        },
      },
      {
        callable: ->(n1, n2) { [:ok] },
        list: {
          [1, 2] => [1, 2],
        },
      },
      {
        callable: ->(n1, *rest) { [:ok] },
        list: {
          [1, 2] => [1, 2],
          [1, 2, 3] => [1, 2, 3],
        },
      },
      {
        callable: ->(n1, *rest, nx, ny) { [:ok] },
        list: {
          [1, 2, 3, 4]    => [1, 2, 3, 4],
          [1, 2, 3, 4, 5] => [1, 2, 3, 4, 5],
          [1, 3, 4]       => [1,    3, 4],
        },
      },
      {
        callable: ->(n1, *rest, n2, k1:, k2:, **keyrest, &block) { [:ok] },
        list: {
          [:n1, :n2, :n3, { k1: 1, k2: 2, k3: 3, }, test_block] => [:n1, :n2, :n3, { k1: 1, k2: 2, }, { k3: 3, }, test_block],
          [:n1,      :n3, { k1: 1, k2: 2, },        test_block] => [:n1,      :n3, { k1: 1, k2: 2, },             test_block],
        },
      },
=begin
      {
        callable: ,
        list: {

        },
      },
=end
    ]

    context 'possible matches' do

      it 'successfully generate the expected payloads' do
        tests.each do |el|
          callable = el[:callable]
          list     = el[:list]

          list.each do |args, result|
            expect(service.generate_args_in(callable: callable, args: args)).to eq result
          end
        end
      end
    end

  end

end
