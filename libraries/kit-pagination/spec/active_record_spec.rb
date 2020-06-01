require 'kit/pagination'
require 'ostruct'

require_relative 'spec_helper'
require_relative 'support/spec_db'

describe Kit::Pagination::ActiveRecord do
  let(:service)         { described_class }

  let(:cursor_data)     { Kit::Pagination::Cursor.cursor_data_for_element(ordering: ordering, element: record)[1][:cursor_data] }
  let(:condition_after) { Kit::Pagination::Condition.condition_for_after(ordering: ordering, cursor_data: cursor_data)[1][:condition] }

  context 'given a cursor data and pagination conditions' do
    # UA: unique attribute, CA: collision attribute
    let(:record)   { OpenStruct.new(ua: 1, ca1: 'A', ca2: 'W') }
    let(:ordering) { [[:ca1, :asc], [:ca2, :desc], [:ua, :asc]] }

    subject { service.to_where_arguments(condition: condition_after) }

    it 'generates the correct `where` values' do
      string, hash = subject

      expect(string).to eq '(((ca1 > :ca1_value)) OR ((ca1 >= :ca1_value) AND (ca2 < :ca2_value)) OR ((ca1 >= :ca1_value) AND (ca2 <= :ca2_value) AND (ua > :ua_value)))'
      expect(hash).to   eq record.to_h.map { |k, v| ["#{ k }_value".to_sym, v] }.to_h
    end
  end

end
