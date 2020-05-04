require_relative '../../rails_helper'

describe "Table Insertion" do
  let(:service) { Kit::Store::Services::Table }
  let(:store)   { Kit::Store::Services::Store.create() }

  let(:selection) { Kit::Store::Services::Table::Selection }

  let(:table_name)  { :users }
  let(:column_name) { :email }

  let(:column_value) { 'test@test.com' }
  let(:test_values) do
    [
      {
        _id: 1,
        email: 'test1@test.com',
      },
      {
        _id: 2,
        email: 'test2@test.com',
      },
    ]
  end

  before do
    service.create(store: store, table_name: table_name)
    service.add_column(store: store, table_name: table_name, column_name: column_name, column_type: String)
  end

  context 'inserting data' do
    subject do
      results = test_values.map do |v|
        data = v.reject { |k, v| k == :_id }
        service.insert(store: store, table_name: table_name, data: data)
      end

      Kit::Organizer.merge(results: results)
    end

    it 'inserts data in the table' do
      status, ctx = subject
      expect(status).to eq :ok

      table = store[:tables][table_name]

      test_values.each_with_index do |values, idx|
        inner_record = table[:data_list][idx]

        values.each do |column_name, expected_column_value|
          current_column_value = selection.get(table: table, inner_record: inner_record, column_name: column_name)[1][:value]
          expect(current_column_value).to eq expected_column_value
        end
      end
    end
  end

end