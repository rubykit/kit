require 'kit/pagination'
require 'ostruct'

require_relative 'support/spec_db'

describe "Pagination page access" do
  let(:records)          { records_base.map { |el| OpenStruct.new(el) } }

  let(:sorted_records)   { SpecDb.order(set: records, ordering: ordering) }

  let(:r1_cursor_data)   { Kit::Pagination::Cursor.cursor_data_for_element(ordering: ordering, element: sorted_records.first) }
  let(:r8_cursor_data)   { Kit::Pagination::Cursor.cursor_data_for_element(ordering: ordering, element: sorted_records.last) }

  let(:conditions_page1) { Kit::Pagination::Conditions.conditions_for_after(ordering:  ordering, cursor_data: r1_cursor_data) }
  let(:conditions_page2) { Kit::Pagination::Conditions.conditions_for_before(ordering: ordering, cursor_data: r8_cursor_data) }

  let(:page_size) { 3 }

  let(:page1) { SpecDb.select_after(ordered_set:  sorted_records, condition: conditions_page1, limit: page_size) }
  let(:page2) { SpecDb.select_before(ordered_set: sorted_records, condition: conditions_page2, limit: page_size) }

  let(:page1_uas) { page1.map { |el| el[:ua] } }
  let(:page2_uas) { page2.map { |el| el[:ua] } }

  RSpec.shared_examples_for 'it paginates correctly' do
    it 'selects the correct elements after cursor' do
      expect(page1_uas).to eq(ref_page1_uas)
    end

    it 'selects the correct elements before cursor' do
      expect(page2_uas).to eq(ref_page2_uas)
    end
  end

  # UA: unique attribute, CA: collsion attribute
  let(:records_base) do
    [
      { ua: 1, ca1: 'A', ca2: 'W' },
      { ua: 2, ca1: 'A', ca2: 'W' },
      { ua: 3, ca1: 'A', ca2: 'X' },
      { ua: 4, ca1: 'A', ca2: 'X' },
      { ua: 5, ca1: 'A', ca2: 'Y' },
      { ua: 6, ca1: 'B', ca2: 'Y' },
      { ua: 7, ca1: 'B', ca2: 'Z' },
      { ua: 8, ca1: 'C', ca2: 'Z' },
    ]
  end

=begin
  ca1↑ ca2↑ ua↑   1 | 2 3 4 | 5 6 7 | 8
  ca1↓ ca2↓ ua↓   8 | 7 6 5 | 4 3 2 | 1
=end
  context 'Ordering combinations 1' do
    let(:ordering)      { [[:ca1, :asc], [:ca2, :asc], [:ua, :asc]] }
    let(:ref_page1_uas) { [2, 3, 4] }
    let(:ref_page2_uas) { [5, 6, 7] }

    it_behaves_like 'it paginates correctly'
  end

=begin
  ca1↑ ca2↓ ua↑   5 | 3 4 1 | 2 7 6 | 8
  ca1↓ ca2↑ ua↓   8 | 6 7 2 | 1 4 3 | 5
=end
  context 'Ordering combinations 2' do
    let(:ordering)      { [[:ca1, :asc], [:ca2, :desc], [:ua, :asc]] }
    let(:ref_page1_uas) { [3, 4, 1] }
    let(:ref_page2_uas) { [2, 7, 6] }

    it_behaves_like 'it paginates correctly'
  end

=begin
ca1↑ ca2↑ ua↓   2 | 1 4 3 | 5 6 7 | 8
ca1↓ ca2↓ ua↑   8 | 7 6 5 | 3 4 1 | 2
=end
  context 'Ordering combinations 3' do
    let(:ordering)      { [[:ca1, :asc], [:ca2, :asc], [:ua, :desc]] }
    let(:ref_page1_uas) { [1, 4, 3] }
    let(:ref_page2_uas) { [5, 6, 7] }

    it_behaves_like 'it paginates correctly'
  end

=begin
ca1↓ ca2↑ ua↑   8 | 6 7 1 | 2 3 4 | 5
ca1↑ ca2↓ ua↓   5 | 4 3 2 | 1 7 6 | 8
=end
  context 'Ordering combinations 4' do
    let(:ordering)      { [[:ca1, :desc], [:ca2, :asc], [:ua, :asc]] }
    let(:ref_page1_uas) { [6, 7, 1] }
    let(:ref_page2_uas) { [2, 3, 4] }

    it_behaves_like 'it paginates correctly'
  end

end