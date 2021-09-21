# Namespace that holds logic to Organize code flow in your app.
module Kit::Organizer

  # Shortcut to `Kit::Organizer::Services::Organize.call`
  def self.call(list:, ctx: {}, filter: nil)
    arguments = { list: list, ctx: ctx, filter: filter }

    Kit::Organizer::Services::Organize.call(**arguments)
  end

  # Shortcut to `Kit::Organizer::Services::Organize.call_for_contract`
  def self.call_for_contract(list:, ctx: {})
    arguments = { list: list, ctx: ctx }

    Kit::Organizer::Services::Organize.call_for_contract(**arguments)
  end

end
