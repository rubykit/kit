require_relative '../rails_helper'

describe 'Aliases' do
  let(:service)       { Kit::Router::Services::Store }
  let(:default_types) { [[:any, :any]] }

  let(:aliases) do
    aliases_list.each do |data|
      service::Alias.add_alias(
        alias_id:     data[:id],
        target_id:    data[:target_id],
        router_store: router_store,
      )
    end
  end

  let(:router_store) { service.create_store }

  let(:endpoints) do
    endpoints_list.each do |data|
      service::Endpoint.add_endpoint(
        uid:          data[:uid],
        target:       data[:target],
        types:        data[:types],
        router_store: router_store,
      )
    end
  end

  let(:resolve) do
    aliases_list.each do |data|
      service::Endpoint.resolve_endpoint(
        alias_record: router_store[:aliases][data[:id]],
        router_store: router_store,
      )
    end
  end

  context 'Registering aliases' do

    context 'with a valid dependency tree' do
      let(:endpoints_list) do
        [
          { uid: :d, target: -> {}, types: default_types },
          { uid: :e, target: -> {}, types: default_types },
        ]
      end

      let(:aliases_list) do
        [
          { id: :c, target_id: :d },
          { id: :b, target_id: :c },
          { id: :a, target_id: :b },
          { id: :c, target_id: :e },
        ]
      end

      it 'register aliases correctly' do
        endpoints
        aliases

        alias_record = router_store[:aliases][:a]
        expect(alias_record[:target_id]).to eq :b

        _status, ctx    = service::Endpoint.get_endpoint(id: :a, router_store: router_store)
        endpoint_record = ctx[:endpoint_record]
        expect(endpoint_record[:id]).to eq :e
      end
    end

    context 'with a circular reference' do
      let(:endpoints_list) do
        [
          { uid: :a, target: -> {}, types: default_types },
        ]
      end

      let(:aliases_list) do
        [
          { id: :b, target_id: :a },
          { id: :c, target_id: :b },
          { id: :d, target_id: :c },
          { id: :b, target_id: :d },
        ]
      end

      it 'detects the issue' do
        endpoints
        expect { aliases }.to raise_error('Kit::Router | aliasing `b` to `d` would create a circular reference')
      end
    end
  end

end
