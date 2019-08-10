module Kit::Pagination::Cursor
  class << self

    def cursor_data_for_element(ordering:, element:)
      ordering
        .map { |name, order| [name, element.send(name)] }
        .to_h
    end

    def encode_cursor(cursor_data:)
      return nil if cursor_data.blank?

      Base64.strict_encode64(cursor_data.to_json)
    end

    def decode_cursor(cursor_str:)
      return nil if cursor_str.blank?

      JSON.parse(Base64.decode64(cursor_str), symbolize_names: true)
    end

  end
end