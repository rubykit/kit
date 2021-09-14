class Array # rubocop:disable Style/Documentation

  # ALlow to call each with keyword arguments matching.
  def each_as_kwargs(&block)
    self.each do |el|
      block.call(**el)
    end
    self
  end

  # ALlow to call map with keyword arguments matching.
  def map_as_kwargs(&block)
    self.map do |el|
      block.call(**el)
    end
  end

end
