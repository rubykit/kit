require_relative '../../rails_helper'
require_relative '../../../lib/kit/contract'

describe 'RubyHelpers' do

  context 'given some arguments and a callable signature' do
    let(:service) { Kit::Contract::Services::RubyHelpers }

    test_block = proc {} # rubocop:disable Lint/EmptyBlock

    tests = [
      {
        callable: ->(k1:, k2:) { [:ok] },
        list:     {
          { kwargs: { k1: 1, k2: 2, k3: 3 } } => { args: [], kwargs: { k1: 1, k2: 2 }, block: nil },
        },
      },
      {
        callable: ->(**_keyrest) { [:ok] },
        list:     {
          { kwargs: { k1: 1, k2: 2, k3: 3 } } => { args: [], kwargs: { k1: 1, k2: 2, k3: 3 }, block: nil },
        },
      },
      {
        callable: ->(**) { [:ok] },
        list:     {
          { kwargs: { k1: 1, k2: 2, k3: 3 } } => { args: [], kwargs: { k1: 1, k2: 2, k3: 3 }, block: nil },
        },
      },
      {
        callable: ->(k1:, k2:, **_keyrest) { [:ok] },
        list:     {
          { kwargs: { k1: 1, k2: 2, k3: 3 } } => { args: [], kwargs: { k1: 1, k2: 2, k3: 3 }, block: nil },
        },
      },
      {
        callable: ->(k1:, k2:, **) { [:ok] },
        list:     {
          { kwargs: { k1: 1, k2: 2, k3: 3 } } => { args: [], kwargs: { k1: 1, k2: 2, k3: 3 }, block: nil },
        },
      },
      {
        callable: ->(_n1, _n2) { [:ok] },
        list:     {
          { args: [1, 2] } => { args: [1, 2], kwargs: {}, block: nil },
        },
      },
      {
        callable: ->(_n1, *_rest) { [:ok] },
        list:     {
          { args: [1, 2] }    => { args: [1, 2],    kwargs: {}, block: nil },
          { args: [1, 2, 3] } => { args: [1, 2, 3], kwargs: {}, block: nil },
        },
      },
      {
        callable: ->(_n1, *) { [:ok] },
        list:     {
          { args: [1, 2] }    => { args: [1, 2],    kwargs: {}, block: nil },
          { args: [1, 2, 3] } => { args: [1, 2, 3], kwargs: {}, block: nil },
        },
      },
      {
        callable: ->(_n1, *_rest, _nx, _ny) { [:ok] },
        list:     {
          { args: [1, 2, 3, 4] }    => { args: [1, 2, 3, 4],    kwargs: {}, block: nil },
          { args: [1, 2, 3, 4, 5] } => { args: [1, 2, 3, 4, 5], kwargs: {}, block: nil },
          { args: [1, 3, 4] }       => { args: [1,    3, 4],    kwargs: {}, block: nil },
        },
      },
      {
        callable: ->(_n1, *, _nx, _ny) { [:ok] },
        list:     {
          { args: [1, 2, 3, 4] }    => { args: [1, 2, 3, 4],    kwargs: {}, block: nil },
          { args: [1, 2, 3, 4, 5] } => { args: [1, 2, 3, 4, 5], kwargs: {}, block: nil },
          { args: [1, 3, 4] }       => { args: [1,    3, 4],    kwargs: {}, block: nil },
        },
      },
      {
        callable: ->(_n1, *_rest, _n2, k1:, k2:, **_keyrest, &block) { [:ok] }, # rubocop:disable Lint/UnusedBlockArgument
        list:     {
          { args: [:n1, :n2, :n3], kwargs: { k1: 1, k2: 2, k3: 3 }, block: test_block } => { args: [:n1, :n2, :n3], kwargs: { k1: 1, k2: 2, k3: 3 }, block: test_block },
          { args: [:n1,      :n3], kwargs: { k1: 1, k2: 2 },        block: test_block } => { args: [:n1,      :n3], kwargs: { k1: 1, k2: 2 },        block: test_block },
        },
      },
      {
        callable: ->(_n1, *, _n2, k1:, k2:, **, &block) { [:ok] }, # rubocop:disable Lint/UnusedBlockArgument
        list:     {
          { args: [:n1, :n2, :n3], kwargs: { k1: 1, k2: 2, k3: 3 }, block: test_block } => { args: [:n1, :n2, :n3], kwargs: { k1: 1, k2: 2, k3: 3 }, block: test_block },
          { args: [:n1,      :n3], kwargs: { k1: 1, k2: 2 },        block: test_block } => { args: [:n1,      :n3], kwargs: { k1: 1, k2: 2 },        block: test_block },
        },
      },
    ]

    context 'possible matches' do

      it 'successfully generate the expected payloads' do
        tests.each do |el|
          callable = el[:callable]
          list     = el[:list]

          list.each do |parameters, result|
            expect(service.generate_parameters_in(callable: callable, parameters: parameters)).to eq result
          end
        end
      end
    end

  end

end
