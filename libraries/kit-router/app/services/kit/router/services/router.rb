#require 'contracts'

module Kit::Router::Services
  module Router
    include Kit::Contract
    Ct = Kit::Router::Contracts

    #Contract KeywordArgs[uid: Or[String, Symbol], target: RespondTo[:call], aliases: ArrayOf[String, Symbol], type: ArrayOf[ArrayOf[Symbol, Symbol]]]]
    def self.register(uid:, aliases:, target:, types: { [:any, :any] => nil })
      #puts "Kit::Router - Registering `#{uid}` (aliases: #{aliases})".colorize(:green)

      # NOTES: does this make it too complex a function signature?
      meta = nil
      if types.is_a?(Hash)
        meta  = types
        types = types.keys
      end

      Kit::Router::Services::Store.add_endpoint(uid: uid, target: target, types: types, meta: meta)
      Kit::Router::Services::Store.add_aliases(target_id: uid, aliases: aliases)

      [:ok]
    end

    EMPTY_TARGET = ->() {}

    def self.register_without_target(uid:, aliases:, types:)
      register(
        uid:     uid,
        aliases: aliases,
        target:  EMPTY_TARGET,
        types:   types,
      )
    end

    # [:any, :any] against [:http, :rails]
    contract Ct::Hash[endpoint_types: Ct::MountTypes, mounter_type: Ct::MountType]
    def self.can_mount?(endpoint_types:, mounter_type:)
      mounter_protocol, mounter_lib = mounter_type

      endpoint_types.each do |record_type|
        record_protocol, record_lib = record_type

        if (record_protocol == mounter_protocol && record_lib == mounter_lib)
          return true
        elsif (record_protocol == mounter_protocol && record_lib == :any)
          return true
        elsif (record_protocol == :any)
          return true
        end
      end

      false
    end

    def self.call(id:, request: nil, params: {})
      record = Kit::Router::Services::Store.get_endpoint(id: id)

      if !request
        request = Kit::Router::Models::Request.new(params: OpenStruct.new(params))
      end

      target = record[:target]

      target.call(request: request)
    end

  end
end
