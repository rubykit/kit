# Namespace that holds logic to Organize code flow in your app.
module Kit::Organizer

  # Shortcut to `Kit::Organizer::Services::Organize.call`
  def self.call(list: nil, ctx: nil, ok: nil, error: nil, safe: nil)
    arguments = { list: list, ctx: ctx, ok: ok, error: error, safe: safe }

    Kit::Organizer::Services::Organize.call(**arguments)
  end

  # Shortcut to `Kit::Organizer::Services::Organize.call_for_contract`
  def self.call_for_contract(list:, ctx: nil)
    ctx     ||= {}
    arguments = { list: list, ctx: ctx }

    Kit::Organizer::Services::Organize.call_for_contract(**arguments)
  end

  # Check if one `error` in `errors` has the expected `code`.
  def self.has_error_code?(code:, errors:)
    errors.each do |error|
      if error.try(:dig, :code) == code
        return [:ok]
      end
    end

    [:error]
  end

end
