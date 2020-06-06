require 'awesome_print'

# Namespace for Debug related logic.
module Kit::Api::JsonApi::Services::Debug

  # Print a text representation of the Query AST.
  #
  # Example output:
  # ```text
  # # rs-name         type    count subsets-count      records-id {parent_id => [child_ids]}
  # top-level         author      2 [2]                [1, 2]
  #  ┣ books          book        6 [3, 3]             {1=>[1, 2, 3], 2=>[4, 5, 6]}
  #  ┃  ┣ author      author      2 [1, 1, 1, 1, 1, 1] {1=>[1], 2=>[1], 3=>[1], 4=>[2], 5=>[2], 6=>[2]}
  #  ┃  ┣ book_stores book_store  7 [1, 1, 1, 1, 2, 1] {1=>[1], 2=>[2], 3=>[3], 4=>[4], 5=>[5, 6], 6=>[7]}
  #  ┃  ┣ chapters    chapter    18 [3, 3, 3, 3, 3, 3] {1=>[1, 2, 3], 2=>[23, 24, 25], 3=>[44, 45, 46], 4=>[63, 64, 65], 5=>[80, 81, 82], 6=>[98, 99, 100]}
  #  ┃  ┣ photos      photo       6 [1, 1, 1, 1, 1, 1] {1=>[1], 2=>[2], 3=>[3], 4=>[4], 5=>[5], 6=>[6]}
  #  ┃  ┗ serie       serie       3 [1, 1, 1, 0, 0, 0] {1=>[1], 2=>[2], 3=>[3], 4=>[], 5=>[], 6=>[]}
  #  ┗ photos         photo       4 [2, 2]             {1=>[1, 2], 2=>[3, 4]}
  #     ┣ author      author      2 [1, 1, 1, 1]       {1=>[1], 2=>[1], 3=>[2], 4=>[2]}
  #     ┣ book        book        3 [1, 1, 1, 1]       {1=>[1], 2=>[1], 3=>[2], 4=>[2]}
  #     ┣ chapter     chapter     3 [1, 1, 1, 1]       {1=>[1], 2=>[1], 3=>[2], 4=>[2]}
  #     ┗ serie       serie       3 [1, 1, 1, 1]       {1=>[1], 2=>[1], 3=>[2], 4=>[2]}
  # ```
  def self.print_query(query_node:)
    list = []

    add_query_nodes(list: list, query_node: query_node)

    lengths = list.reduce(nil) do |acc, el|
      !acc ? el.map(&:size) : (acc.map.with_index { |acc_el, idx| [acc_el, el[idx].size].max })
    end

    list.each do |parts|
      output = [
        parts[0],
        parts[1].ljust(lengths[1] + lengths[0] - parts[0].size).yellow,
        parts[2].ljust(lengths[2]).blue,
        parts[3].rjust(lengths[3]).green,
        parts[4].to_s.ljust(lengths[4]),
        parts[5].to_s,
      ]

      puts output.join(' ')
    end
  end

  def self.add_query_nodes(list:, query_node: nil, relationship: nil, level: 0, pre_str: '', is_last: false)
    query_node ||= relationship[:child_query_node]

    parts = [
      "#{ pre_str }#{ (level > 0) ? (is_last ? '  ┗' : '  ┣') : '' }", # rubocop:disable Style/NestedTernaryOperator
      (relationship ? relationship[:name] : 'top-level-node'),
      query_node[:resource][:name],
      query_node[:records]&.count,
    ]

    if relationship
      parts << relationship[:parent_query_node][:records]&.map { |record| record[:relationships][relationship[:name]].size }
      parts << relationship[:parent_query_node][:records]&.map { |record| [record[:raw_data].id, record[:relationships][relationship[:name]].map { |el| el[:raw_data].id }] }.to_h
    else
      parts << [query_node[:records]&.count]
      parts << query_node[:records]&.map { |el| el[:raw_data].id }
    end

    list << parts.map(&:to_s)

    if level > 0
      pre_str += is_last ? '   ' : '  ┃'
    end

    query_node[:relationships].each_with_index do |rs_data, idx|
      _rs_name, rs = rs_data
      rs_is_last   = query_node[:relationships].size == (idx + 1)

      add_query_nodes(list: list, relationship: rs, level: level + 1, pre_str: pre_str.dup, is_last: rs_is_last)
    end
  end

end
