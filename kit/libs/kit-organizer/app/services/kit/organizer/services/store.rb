module Kit::Organizer::Services::Store

  def self.register(store: organizer_store, id:, target:)
    id = id.to_sym

    if !target.respond_to?(:call)
      raise "Kit::Organizer::Store | target `#{id}` is not a callable"
    end

    store[id] = {
      target: target,
    }
  end

  def self.get(store: organizer_store, id:)
    id     = id.to_sym
    record = store[id]

    if !record
      raise "Kit::Router | unknown route `#{id}`"
    end

    record[:target]
  end

  def self.organizer_store
    @organizer_store ||= create_store
  end

  def self.create_store
    {}
  end

end