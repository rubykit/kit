require_relative '../rails_helper'

describe "Aliases" do
  let(:service)       { Kit::Router::Services::Store }
  let(:default_types) { [[:any, :any]] }

  let(:aliases_list) do
    [
      { id: :c, target_id: :d, },
      { id: :b, target_id: :c, },
      { id: :a, target_id: :b, },
      { id: :m, target_id: :b, },
      { id: :y, target_id: :c, },
      { id: :x, target_id: :y, },
      { id: :c, target_id: :e, },
    ]
  end

  let(:aliases) do
    aliases_list.each do |data|
      service.add_alias(
        alias_id:      data[:id],
        target_id:     data[:target_id],
        router_store:  router_store,
      )
    end
  end

  let(:router_store) { service.create_store }

  let(:endpoints_list) do
    [
      { uid: :d, target: ->() {}, types: default_types, },
      { uid: :e, target: ->() {}, types: default_types, },
    ]
  end

  let(:endpoints) do
    endpoints_list.each do |data|
      service.add_endpoint(
        uid:          data[:uid],
        target:       data[:target],
        types:        data[:types],
        router_store: router_store,
      )
    end
  end

  let(:resolve) do
    aliases_list.each do |data|
      service.resolve_endpoint(
        alias_record: router_store[:aliases][data[:id]],
        router_store: router_store,
      )
    end
  end

  context 'Registering aliases' do
    before do
      endpoints
      aliases
      resolve
    end

    it 'register aliases correctly' do
      alias_record = router_store[:aliases][:a]
      expect(alias_record[:target_id]).to eq :b
      expect(alias_record[:cached_endpoint][:uid]).to eq :e
    end
  end

end