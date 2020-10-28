# Local storage for registered Contracts.
# TODO: move this to Kit::Store when available
module Kit::Contract::Services::Store

  def self.add_and_generate_key(value:, store: nil)
    store ||= self.local_store
    _, ctx  = get_next_key(store: store, sequence: store[:metadata][:sequences][:keys])
    key     = ctx[:key]

    store[:data][key] = value

    [:ok, key: key]
  end

  def self.get_next_key(sequence:, store: nil)
    store ||= self.local_store

    new_value = nil

    loop do
      new_value = sequence[:get_next_value].call(last_value: sequence[:last_value])
      sequence[:last_value] = new_value

      break if !store[:data].key?(new_value)
    end

    [:ok, key: new_value]
  end

  def self.get(key:, store: nil)
    store ||= self.local_store

    value = store[:data]&.dig(key) || {}

    [:ok, value: value]
  end

  def self.local_store
    @local_store ||= {
      data:     {},
      metadata: {
        sequences: {
          keys: {
            last_value:     0,
            get_next_value: ->(last_value:) { last_value + 1 },
          },
        },
      },
    }
  end

end
