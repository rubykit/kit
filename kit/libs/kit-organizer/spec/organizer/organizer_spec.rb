require_relative '../rails_helper'
require_relative '../../lib/kit/organizer'

describe Kit::Organizer do

  module TestModules
    module Organizer
      def self.m1(b:, c: {})
        [:ok, b.merge(c)]
      end
    end
  end

  context 'with different types of callable' do

    let(:list) do
      [
        ->(a:) { [:ok, a] },
        ->(**)  { [:ok] },
        TestModules::Organizer.method(:m1),
      ]
    end

    context 'and a valid ctx' do

      tests = {
        { a: { b: { d: 4, }, }, }                   => { a: { b: { d: 4, }, }, b: { d: 4, }, d: 4, },
        { a: { b: { d: 4, }, c: { f: 6 }, }, }      => { a: { b: { d: 4, }, c: { f: 6 }, }, b: { d: 4, }, c: { f: 6 }, d: 4, f: 6, },
        { a: { d: 4, }, b: { e: 5 }, }              => { a: { d: 4, }, b: { e: 5 }, d: 4, e: 5, },
        { a: { d: 4, }, b: { e: 5 }, c: { f: 6 }, } => { a: { d: 4, }, b: { e: 5 }, c: { f: 6 }, d: 4, e: 5, f: 6, },
      }

      tests.each do |ctx_in, expected_ctx_out|
        it 'succeeds' do
          status, ctx_out = described_class.call(list: list, ctx: ctx_in)

          expect(status).to eq(:ok)
          expect(ctx_out).to eq(expected_ctx_out)
        end
      end

    end

    context 'and an invalid flow' do

      tests = {
        { a: { c: 2 }, } => [ArgumentError, 'missing keyword: :b'],
        { b: { c: 2 }, } => [ArgumentError, 'missing keyword: :a'],
      }

      tests.each do |ctx_in, expected_exception|
        expected_exception_class, expected_exception_msg = expected_exception
        it 'fails' do
          expect { described_class.call(list: list, ctx: ctx_in) }.to raise_error(
            an_instance_of(expected_exception_class).and(having_attributes(message: expected_exception_msg))
          )
        end
      end

    end

  end

end