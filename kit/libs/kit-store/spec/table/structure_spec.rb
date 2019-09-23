require_relative '../rails_helper'
require_relative '../../lib/kit/store'

describe "Table Structure" do
  let(:service) { Kit::Store::Services::Table }
  let(:store)   { Kit::Store::Services::Store.create() }

  context 'creating a table' do
    subject { service.create(store: store, table_name: table_name) }
    let(:table_name) { :users }

    it 'creates a new table' do
      status, ctx = subject
      expect(status).to eq :ok
      expect(store[:tables][table_name]).not_to be nil
      expect(store[:tables][table_name][:columns_hash][:_id]).not_to be nil
    end
  end

  context 'creating columns' do
    let(:table_name)  { :users }
    let(:column_name) { :email }
    let(:column_type) { String }

    before do
      service.create(store: store, table_name: table_name)
    end

    subject { service.add_column(store: store, table_name: table_name, column_name: column_name, column_type: column_type) }

    context 'when the column does not already exists' do
      it 'successfully creates a new column' do
        status, ctx = subject
        expect(status).to eq :ok
        expect(store[:tables][table_name][:columns_hash][column_name]).not_to be nil
      end
    end

    context 'when the column already exists' do
      before do
        service.add_column(store: store, table_name: table_name, column_name: column_name, column_type: column_type)
      end

      it 'errors out' do
        status, ctx = subject
        expect(status).to eq :error
        expect(ctx[:errors][0][:detail]).to eq 'Kit::Store | Table `users` column `email` column already exists'
      end
    end

  end

end