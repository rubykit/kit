# The `ActiveRecordResource` module is a helper to generate a Hash that will pass the `Contract::Resource` requirements.
#
# While you can always generate a Resource yourself, this helps do it in a less verbose way.
class Kit::Api::Resources::ActiveRecordResource

  # Default filter configuration based on field type
  def self.default_filters
    {
      id:         [:eq, :in],
      id_string:  [:eq, :in],
      id_numeric: [:eq, :in],

      boolean:    [:eq],
      date:       [:eq, :in, :gt, :gte, :lt, :lte],
      numeric:    [:eq, :in, :gt, :gte, :lt, :lte],
      string:     [:eq, :in, :contain, :start_with, :end_with],
    }
  end

  # Default sort_field behaviour based on field type.
  #
  # Please remember that sort fields do not necessarily need to correspond to resource attribute and relationship names.
  #
  # - `sortable` means we want to create a sort criteria for the field, with the same name.
  # - `unique` means we don't need a tie-breaker for pagination purposes
  # - `tie_breaker` is the unique field to use when a tie breaker is needed. The default config assumes that there will likely only be one Id type field per Resource, but that might not hold true.
  def self.default_sort_fields
    regular = {
      sortable: true,
      unique:   false,
      order:    :asc,
    }
    id      = {
      sortable: true,
      unique:   true,
      order:    :asc,
    }

    {
      id:         id,
      id_string:  id,
      id_numeric: id,

      boolean:    regular,
      date:       regular,
      numeric:    regular,
      string:     regular,
    }
  end

  # Returns a Resource we actualy depend on, everything else is syntaxic sugar.
  # after Ct::Resource # TODO: in order for this to work, add `ActiveSupport::Concern` support in `Kit::Contract`
  def self.to_h
    {
      name:              name,

      fields:            fields,
      sort_fields:       sort_fields,
      filters:           filters,
      relationships:     relationships,

      data_resolver:     self.method(:data_resolver),
      record_serializer: self.method(:record_serializer),

      linker:            self.linker,
      paginator:         self.paginator,

      extra:             {
        model_read:  self.model_read,
        model_write: self.model_write,
      },
    }
  end

  # Should contain the name (type) of the Resource
  def self.name
    raise 'ActiveRecordResource - Please implement the `name` module method.'
  end

  # Should contain the ActiveRecord model
  def self.model_read
    raise 'ActiveRecordResource - Please implement the `model_read` module method.'
  end

  def self.model_write
    raise 'ActiveRecordResource - Please implement the `model_write` module method.'
  end

  # Hold data to generate `fields`, `filters` && `sort_fields`.
  #
  # ### Example
  #
  # The following:
  # ```ruby
  # def self.fields_setup
  #   {
  #     id:            { type: :id_numeric, sort_field: { default: true, tie_breaker: true } },
  #     created_at:    { type: :date },
  #     updated_at:    { type: :date },
  #     name:          { type: :string },
  #     date_of_birth: { type: :date },
  #     date_of_death: { type: :date, sort_field: { order: :desc } },
  #   }
  # end
  #```
  #
  # Is equivalent to declarings:
  # ```ruby
  # def self.fields
  #  [:id, :created_at, :updated_at, :name, :date_of_birth, :date_of_death]
  # end
  #
  # def self.filters
  #   {
  #     id:            [:eq, :in],
  #     created_at:    [:eq, :in, :gt, :gte, :lt, :lte],
  #     updated_at:    [:eq, :in, :gt, :gte, :lt, :lte],
  #     name:          [:eq, :in, :contain, :start_with, :end_with],
  #     date_of_birth: [:eq, :in, :gt, :gte, :lt, :lte],
  #     date_of_death: [:eq, :in, :gt, :gte, :lt, :lte],
  #   }
  # end
  #
  # def self.sort_fields
  #   {
  #     id:            { order: [[:id,            :asc]],              default: true },
  #     created_at:    { order: [[:created_at,    :asc],  [:id, :asc]] },
  #     updated_at:    { order: [[:updated_at,    :asc],  [:id, :asc]] },
  #     name:          { order: [[:name,          :asc],  [:id, :asc]] },
  #     date_of_birth: { order: [[:date_of_birth, :asc],  [:id, :asc]] },
  #     date_of_death: { order: [[:date_of_death, :desc], [:id, :asc]] },
  #   }
  # end
  # ```
  def self.fields_setup
    raise 'ActiveRecordResource - Please implement the `fields_setup` module method.'
  end

  def self.fields
    fields_setup&.keys
  end

  def self.sort_fields
    list = fields_setup.map do |name, data|
      [name, {}
        .merge(Kit::Api::Resources::ActiveRecordResource.default_sort_fields[data[:type]] || {})
        .merge(data[:sort_field] || {}),
      ]
    end.to_h

    if !list.any? { |_, data| data[:default] == true }
      raise "ActiveRecordResource - No default sort for Resource `#{ self.class.name }`"
    end

    tie_breaker_sort = list.filter_map { |name, data| [name, (data[:order] == :asc) ? :asc : :desc] if data[:tie_breaker] }
    if tie_breaker_sort.size != 1
      raise "ActiveRecordResource - No tie-breaker or too many for Resource `#{ self.class.name }`"
    end

    tie_breaker_sort = tie_breaker_sort[0]

    list
      .map do |name, data|
        [name, {
          order:   [[name, (data[:order] == :asc) ? :asc : :desc], (!data[:unique] ? tie_breaker_sort : nil)].compact,
          default: (data[:default] == true),
        },]
      end
      .to_h
  end

  def self.filters
    fields_setup
      .filter_map { |name, data| [name, Kit::Api::Resources::ActiveRecordResource.default_filters[data[:type]]] if data[:type] }
      .to_h
  end

  def self.relationships
    raise 'ActiveRecordResource - Please implement the `relationships` module method.'
  end

  def self.data_resolver(query_node:)
    Kit::Api::Services::Resolvers::ActiveRecord.data_resolver(
      query_node: query_node,
      model:      query_node[:resource][:extra][:model_read],
    )
  end

  def self.record_serializer(record:)
    Kit::Api::JsonApi::Services::Serializers::ActiveRecord.record_serializer(record: record)
  end

  def self.linker
    Kit::Api::JsonApi::Services::Linkers::DefaultLinker.to_h
  end

  def self.paginator
    Kit::Api::JsonApi::Services::Paginators::Cursor.to_h
  end

=begin
    def resource_url(resource_id:)
      raise 'Implement me.'
    end

    def relationship_url(resource_id:, relationship_name:)
      raise 'Implement me.'
    end

    def links_single(record:)
      links = {
        self: resource_url(resource_id: record[:resource_object][:id]),
      }

      [:ok, links: links]
    end

    def links_collection(query_node:, records:)
      records_list = records

      links = {
        self: "https://top_level_collection-self_link?first=#{ records_list.first&.dig(:resource_object, :id) }&last=#{ records_list.last&.dig(:resource_object, :id) }",
        prev: '...',
        next: '...',
      }

      [:ok, links: links]
    end

    def links_relationship_single(record:, relationship:)
      records_list = record[:relationships][relationship[:name]]

      links = {
        self:    "https://to_one_rel-self_link?el=#{ records_list.first&.dig(:resource_object, :id) }",
        related: "https://to_one-relrelated_link?el=#{ records_list.first&.dig(:resource_object, :id) }",
      }

      [:ok, links: links]
    end

    def links_relationship_collection(record:, relationship:)
      records_list = record[:relationships][relationship[:name]]

      links = {
        self:    "https://to_many_rel-self_link?first=#{ records_list.first&.dig(:resource_object, :id) }&last=#{ records_list.last&.dig(:resource_object, :id) }",
        related: "https://to_many_rel-related_link?first=#{ records_list.first&.dig(:resource_object, :id) }&last=#{ records_list.last&.dig(:resource_object, :id) }",
      }

      [:ok, links: links]
    end
=end

end
