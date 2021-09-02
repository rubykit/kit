# TODO: move this to a gem?

class Array

  def each_as_kwargs(&block)
    self.each do |el|
      block.call(**el)
    end
    self
  end

end
