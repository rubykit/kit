class Array

  def organize(ctx: {}, **rest)
    args = { list: self, }.merge({ ctx: ctx, }).merge(rest)

    Kit::Organizer.call(args)
  end

end