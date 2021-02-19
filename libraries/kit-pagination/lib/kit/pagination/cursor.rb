# Namespace for cursor operations.
module Kit::Pagination::Cursor

  # Given an `ordering`, returns cursor data as a hash for `element`.
  #
  # By default, cursor are meant to be exclusive (the element it is generated from won't be fetched in the set).
  # If `included` is set to true, add meta data to the cursor to indicate element should be included in the set when retrieving it.
  #
  # ⚠️ Warning: `included_field_name` is used as the meta field name that will be embedded in the cursor.
  #   Erroneous behavior will occur if it also a field name present in `ordering`.
  #   When that's the case, use `included_field_name` to specify a different name.
  #
  # Examples
  # ```irb
  # element  = { id: 3, created_at: 1590596043, color: 'teal' }
  # ordering = [[:created_at, :desc], [:id, :asc]]
  # cursor_data_for_element(element: element, ordering: ordering)
  # {
  #    created_at: 1590596043,
  #    id:         3,
  # }
  # cursor_data_for_element(element: element, ordering: ordering, included: true)
  # {
  #    created_at: 1590596043,
  #    id:         3,
  #    _inc:       true,
  # }
  # ```
  def self.cursor_data_for_element(ordering:, element:, included: false, included_field_name: :_inc)
    # NOTE: rather unlikely to happen, but better sage than sorry!
    if ordering.map { |el| el[0] }.include?(included_field_name)
      [:error, errors: [{ detail: 'Field collision: please specify a different `included_field_name` (current used in ordering)' }]]
    end

    result = ordering
      .map { |name, _order| [name, element[name]] }
      .to_h

    if included
      result[included_field_name] = true
    end

    [:ok, cursor_data: result]
  end

  # Serialiaze cursor data to a base64 string.
  def self.encode_cursor_base64(cursor_data:)
    return nil if cursor_data.blank?

    encoded_cursor = Base64.strict_encode64(cursor_data.to_json)

    [:ok, encoded_cursor: encoded_cursor]
  end

  # Deserialiaze cursor data from a base64 string.
  def self.decode_cursor_base_64(encoded_cursor:)
    return nil if cursor_str.blank?

    cursor_data = JSON.parse(Base64.decode64(cursor_str), symbolize_names: true)

    [:ok, cursor_data: cursor_data]
  end

end
