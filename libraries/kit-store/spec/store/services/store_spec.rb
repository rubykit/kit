require_relative '../../rails_helper'
require_relative '../../../lib/kit/store'

describe 'Store' do
  let(:service)       { Kit::Store::Services::Store }

  context 'creating a store' do
    subject { service.create() }

    it 'creates a new store' do
      expect(subject).to be_a(Hash)
    end

  end
end
