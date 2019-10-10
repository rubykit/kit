require_relative '../rails_helper'

describe "Table Selection" do
  let(:service) { Kit::Store::Services::Table }
  let(:store)   { Kit::Store::Services::Store.create() }

  let(:table_name)  { :users }
  let(:column_name) { :email }

  let(:column_value) { 'test@test.com' }
  let(:test_values) do
    [
      {
        email: 'test1@test.com',
      },
      {
        email: 'test2@test.com',
      },
    ]
  end

  before do
    service.create(store: store, table_name: table_name)
    service.add_column(store: store, table_name: table_name, column_name: column_name, column_type: String)

    test_values.map do |data|
      service.insert(store: store, table_name: table_name, data: data)
    end
  end

  context 'selecting data' do
    let(:limit) { 1 }
    let(:order) { [[:_id, :desc]] }

    subject { service.select(store: store, from: table_name, order: order, limit: limit) }

    it 'selects the data from the table' do
      status, ctx = subject
      expect(status).to eq :ok

      records = ctx[:records]
      expect(records.size).to eq 1

      record     = records[0]
      ref_record = test_values[1]

      expect(record[:_id]).to eq 2

      ref_record.each do |k, ref_value|
        expect(record[k]).to eq ref_value
      end
    end
  end

end