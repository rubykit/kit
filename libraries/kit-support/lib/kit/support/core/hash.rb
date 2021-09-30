class Hash # rubocop:disable Style/Documentation

  # Slice + renaming behaviour when argument is a hash.
  #
  # Ex:
  # ```ruby
  # { a: 1, b: 2, c: 3 }.slice_as(:a, { b: :b2 }, :d) == { a: 1, b2: 2 }
  # ```
  #
  # ☠️ Danger: if you are using hashes as keys, this will create issues!
  def slice_as(*args)
    result = {}

    args.each do |el|
      if el.is_a?(::Hash)
        el.each do |before, after|
          result[after] = self[before] if self.key?(before)
        end
      elsif self.key?(el)
        result[el] = self[el]
      end
    end

    result
  end

end
