require_relative '../../rails_helper'
require_relative '../../../lib/kit/organizer'

describe Kit::Organizer::Services::Callable::Alias do

  describe '.resolve' do
    subject { described_class.resolve(args: payload, store: store) }

    let(:store) { described_class.create_store }

    let(:payload) { [:alias, alias_name] }

    context 'with no registered alias' do
      let(:alias_name) { :undefined_alias }

      it 'fails' do
        expect { subject }.to raise_error("Kit::Organizer::Services::Callable::Alias | unknown alias `#{ alias_name }`")
      end
    end

    context 'with a registered alias' do
      let(:alias_name) { :registered_alias }
      let(:target)     { -> {} }

      before { described_class.register(store: store, id: alias_name, target: target) }
      it 'returns the aliased target' do
        status, ctx = subject
        expect(status).to         eq(:ok)
        expect(ctx[:callable]).to eq(target)
      end
    end

  end

end
