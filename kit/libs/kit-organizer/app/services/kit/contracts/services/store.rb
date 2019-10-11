module Kit::Contracts::Services::Store

  def self.add(store: nil, class_name:, method_name:, contracts:)
    store ||= self.local_store
    key     = [class_name.to_sym, method_name.to_sym]

    store[key] = contracts
  end

  def self.get(store: nil, class_name:, method_name:)
    store ||= self.local_store
    key     = [class_name.to_sym, method_name.to_sym]

    store[key] || {}
  end

  def self.local_store
    @local_store ||= {}
  end

end
