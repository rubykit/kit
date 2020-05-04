module Kit::Contract::Services::Store

  # TODO: move this to Kit::Store when available

  def self.add_and_generate_key(store: nil, value:)
    store    ||= self.local_store

    _, ctx     = get_next_key(store: store, sequence: store[:metadata][:sequences][:keys])
    key        = ctx[:key]

    store[:data][key] = value

    [:ok, key: key]
  end

  def self.get_next_key(store: nil, sequence:)
    store ||= self.local_store

    new_value = nil

    loop do
      new_value = sequence[:get_next_value].call(last_value: sequence[:last_value])
      sequence[:last_value] = new_value

      if !store[:data].has_key?(new_value)
        break
      end
    end

    [:ok, key: new_value]
  end

  def self.get(store: nil, key:)
    store ||= self.local_store

    value = store[:data]&.dig(key) || {}

    [:ok, value: value]
  end

  def self.local_store
    @local_store ||= {
      data:    {},
      metadata: {
        sequences: {
          keys: {
            last_value: 0,
            get_next_value: ->(last_value:) { last_value + 1 },
          },
        },
      },
    }
  end

end