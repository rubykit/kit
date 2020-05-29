class Array # rubocop:disable Style/Documentation

  # Helper method to be able to call organize directly on an Array.
  def organize(ctx: {}, **rest)
    args = { list: self }
      .merge({ ctx: ctx })
      .merge(rest)

    Kit::Organizer.call(args)
  end

end
