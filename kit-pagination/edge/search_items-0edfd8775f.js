

searchNodes = [
  {
    "type": "module",
    "ref": "Kit.html#Kit-module",
    "title": "Top Level Namespace::Kit",
    "doc": "rubocop:disable Style/ClassAndModuleChildren "
  },
  {
    "type": "module",
    "ref": "Kit.Pagination.html#Pagination-module",
    "title": "Kit::Pagination",
    "doc": "Pagination logic for sets. "
  },
  {
    "type": "module",
    "ref": "Kit.Pagination.ActiveRecord.html#ActiveRecord-module",
    "title": "Kit::Pagination::ActiveRecord",
    "doc": "Logic to generate ActiveRecord compatible parameters "
  },
  {
    "type": "module",
    "ref": "Kit.Pagination.Condition.html#Condition-module",
    "title": "Kit::Pagination::Condition",
    "doc": "Generate conditions for after / before cursors "
  },
  {
    "type": "module",
    "ref": "Kit.Pagination.Cursor.html#Cursor-module",
    "title": "Kit::Pagination::Cursor",
    "doc": "Namespace for cursor operations. "
  },
  {
    "type": "class method",
    "ref": "Kit.Pagination.ActiveRecord.html#to_where_arguments-class_method",
    "title": "Kit::Pagination::ActiveRecord#to_where_arguments",
    "doc": "Generate interpolation string + values hash that can be used in ActiveRecord's where. Examples: cursor_data = { id: 1, first: 'A', last: 'W' } ordering = [[:first, :asc], [:last, :desc], [:id, :asc]] condition = Kit::Pagination::Conditions.conditions_for_after(ordering: ordering, cursor_data: cursor_data)[1][:condition] to_where_arguments(conditions: condition) [ \"(((first > :first_value)) OR ((first >= :first_value) AND (last < :last_value)) OR ((first >= :first_value) AND (last <= :last_value) AND (id > :id_value)))\", { first_value: 'A', last_value: 'W', id: 1 }, ] "
  },
  {
    "type": "class method",
    "ref": "Kit.Pagination.ActiveRecord.html#to_order_arguments-class_method",
    "title": "Kit::Pagination::ActiveRecord#to_order_arguments",
    "doc": "Generate ordering hash that can be used in ActiveRecord's order. "
  },
  {
    "type": "class method",
    "ref": "Kit.Pagination.ActiveRecord.html#to_string-class_method",
    "title": "Kit::Pagination::ActiveRecord#to_string",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Pagination.ActiveRecord.html#to_values_hash-class_method",
    "title": "Kit::Pagination::ActiveRecord#to_values_hash",
    "doc": ""
  },
  {
    "type": "class method",
    "ref": "Kit.Pagination.Condition.html#condition_for_after-class_method",
    "title": "Kit::Pagination::Condition#condition_for_after",
    "doc": "Generate a condition Hash to retrieve elements after the original cursor element. The cursor might contain meta information to include the original element in the condition. "
  },
  {
    "type": "class method",
    "ref": "Kit.Pagination.Condition.html#condition_for_before-class_method",
    "title": "Kit::Pagination::Condition#condition_for_before",
    "doc": "Generate a condition Hash to retrieve elements before the original cursor element. The cursor might contain meta information to include the original element in the condition. "
  },
  {
    "type": "class method",
    "ref": "Kit.Pagination.Condition.html#query_data-class_method",
    "title": "Kit::Pagination::Condition#query_data",
    "doc": "Generate a condition from cursor_data and ordering. "
  },
  {
    "type": "class method",
    "ref": "Kit.Pagination.Cursor.html#cursor_data_for_element-class_method",
    "title": "Kit::Pagination::Cursor#cursor_data_for_element",
    "doc": "Given an ordering, returns cursor data as a hash for element. By default, cursor are meant to be exclusive (the element it is generated from won't be fetched in the set). If included is set to true, add meta data to the cursor to indicate element should be included in the set when retrieving it. ⚠️ Warning: included_field_name is used as the meta field name that will be embedded in the cursor. Erroneous behavior will occur if it also a field name present in ordering. When that's the case, use included_field_name to specify a different name. Examples element = { id: 3, created_at: 1590596043, color: 'teal' } ordering = [[:created_at, :desc], [:id, :asc]] cursor_data_for_element(element: element, ordering: ordering) { created_at: 1590596043, id: 3, } cursor_data_for_element(element: element, ordering: ordering, included: true) { created_at: 1590596043, id: 3, _inc: true, } "
  },
  {
    "type": "class method",
    "ref": "Kit.Pagination.Cursor.html#encode_cursor_base64-class_method",
    "title": "Kit::Pagination::Cursor#encode_cursor_base64",
    "doc": "Serialiaze cursor data to a base64 string. "
  },
  {
    "type": "class method",
    "ref": "Kit.Pagination.Cursor.html#decode_cursor_base_64-class_method",
    "title": "Kit::Pagination::Cursor#decode_cursor_base_64",
    "doc": "Deserialiaze cursor data from a base64 string. "
  },
  {
    "type": "constant",
    "ref": "Kit.Pagination.ActiveRecord.html#OperatorsStr-constant",
    "title": "Kit::Pagination::ActiveRecord::OperatorsStr",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Pagination.Condition.html#OPERATORS_MAPPING-constant",
    "title": "Kit::Pagination::Condition::OPERATORS_MAPPING",
    "doc": ""
  },
  {
    "type": "constant",
    "ref": "Kit.Pagination.html#VERSION-constant",
    "title": "Kit::Pagination::VERSION",
    "doc": ""
  },
  {
    "type": "extra",
    "ref": "README.html",
    "title": "Kit::Pagination",
    "doc": "Kit::Pagination Kit::Pagination is a library that allows sets pagination with different strategies. To learn more about Kit::Pagination, see Kit::Pagination's documentation. To understand how we think about Pagination, see the About Pagination guide. To learn how to use Kit::Pagination in your projects, see the Usage guide. Features Identify sets boundary. Generate cursors. In progress: Add relative pagination strategy. Copyright & License Copyright (c) 2020, Nathan Appere. Kit::Pagination is licensed under MIT License. "
  },
  {
    "type": "extra",
    "ref": "about_pagination.html",
    "title": "About Pagination",
    "doc": "About Pagination For a set that contains N elements, pagination is way to obtain subsets of this set (often with ordering constraints). This subset can be referred to as a page\". Page ID In order to identify that subset, you will need a subset identifier (or subset id, page id). This page id contains the data necessary to obtain a subset. Transparent Opaque Example page=2 page=LKJlhJ_h2 Pagination data Visible to the pagination user Not visible to the pagination user Access Sequential or not Sequential only Used when * The pagination data is simple * Non sequential access is needed * The pagination data is complex * non sequential access is not needed Here the client receives an opaque chunk of data, the cursor, that is sent back to get the next or previous page. "
  },
  {
    "type": "extra",
    "ref": "absolute_pagination.html",
    "title": "Absolute pagination",
    "doc": "Absolute pagination With this strategy, the subset id will always returns the same subset (minus elements that have been deleted since that access). The subset id needs to contain data that allows to identify the subset in an absolute way: often, a unique proprety of the first element and last element of the subset. To avoid collisions between subsets, the last (or least important) ordering parameter used always need to be unique. Examples: Ordering Status Note [[:uid, :asc], [:created_at, :desc]] Valid But created_at will never be used since uid is already unique [[:created_at, :desc]] Invalid You might have elements of the sets that have similar creation timestamps. This can lead to collisions between subsets: the same element can be returned in different pages [[[:created_at, :desc], [:uid, :asc]] Valid Even if you don't care about :uid in itself, adding it allows to uniquely identify elements of the set. "
  },
  {
    "type": "extra",
    "ref": "relative_pagination.html",
    "title": "relative_pagination",
    "doc": ""
  },
  {
    "type": "extra",
    "ref": "usage.html",
    "title": "Usage",
    "doc": "Usage Installation Add this line to your application's Gemfile: gem 'kit-pagination' "
  }
];