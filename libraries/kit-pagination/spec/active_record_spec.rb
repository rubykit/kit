require 'kit/pagination'
require 'ostruct'

require_relative 'support/spec_db'

describe Kit::Pagination::ActiveRecord do
  let(:service) { described_class }

  let(:cursor_data) { Kit::Pagination::Cursor.cursor_data_for_element(ordering: ordering, element: record) }

  let(:conditions_after)  { Kit::Pagination::Conditions.conditions_for_after(ordering:  ordering, cursor_data: cursor_data)}

  context 'given a cursor data and pagination conditions' do
    # UA: unique attribute, CA: collsion attribute
    let(:record)   { OpenStruct.new(ua: 1, ca1: 'A', ca2: 'W') }
    let(:ordering) { [[:ca1, :asc], [:ca2, :desc], [:ua, :asc]] }

    subject { service.to_where_arguments(conditions: conditions_after) }

    it 'generates the correct `where` values' do
      string, hash = subject

      expect(string).to eq "(((ca1 > :ca1_value)) OR ((ca1 >= :ca1_value) AND (ca2 < :ca2_value)) OR ((ca1 >= :ca1_value) AND (ca2 <= :ca2_value) AND (ua > :ua_value)))"
      expect(hash).to   eq record.to_h.map { |k, v| ["#{k}_value".to_sym, v] }.to_h
    end
  end

end