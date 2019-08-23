class Array

  def organize(ctx = {})
    Kit::Organizer.call({
      ctx:  ctx,
      list: self,
    })
  end

end