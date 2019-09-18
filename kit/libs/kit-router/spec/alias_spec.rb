require_relative 'rails_helper'

describe "Aliases" do
  let(:service)       { Kit::Router::Services::Store }
  let(:default_types) { [[:all, :all]] }

  let(:alias_list) do
    [
      { id: :c, target_id: :d, },
      { id: :b, target_id: :c, },
      { id: :a, target_id: :b, },
      { id: :m, target_id: :b, },
      { id: :y, target_id: :c, },
      { id: :x, target_id: :y, },
    ]
  end

  let(:aliases) do
    alias_list.each do |data|
      service.add_alias(
        alias_id:      data[:id],
        target_id:     data[:target_id],
        router_store:  router_store,
      )
    end
  end

  let(:aliases_store)     { {} }
  let(:endpoints_store)   { {} }
  let(:mountpoints_store) { {} }

  let(:router_store) do
    {
      aliases:     aliases_store,
      endpoints:   endpoints_store,
      mountpoints: mountpoints_store,
    }
  end

  let(:endpoint_uid) { :d }
  let(:endpoint) do
    service.add_endpoint(
      uid:             endpoint_uid,
      target:          nil,
      types:           default_types,
      router_store:    router_store,
    )
  end

  let(:resolve) do
    alias_list.each do |data|
      service.resolve_endpoint(
        alias_record:  aliases_store[data[:id]],
        router_store:  router_store,
      )
    end
  end

  context 'Registering aliases' do
    before do
      endpoint
      aliases
      resolve
    end

    it 'register aliases correctly' do
      alias_record = aliases_store[:a]
      expect(alias_record[:target_id]).to eq :b
      expect(alias_record[:cached_endpoint][:uid]).to eq :d
    end
  end

end