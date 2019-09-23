module Kit::Store::Services::Table
  module Selection
    extend T::Sig

    sig do
      params(
        store:      T.untyped,
        table_name: Symbol,
        where:      T::Array[T::Hash[T.untyped, T.untyped]],
        order:      T::Array[[T.untyped, T.any(Integer,Symbol)]]
      ).returns(T::Array[T::Hash[T.untyped, T.untyped]])
    end
    def self.select(store:, from:, select:, where: [], limit: nil, order: nil)
      if !where.is_a?(Array)
        where = [where]
      end

      filters = []
      if where.each do |filter|
        if filter.respond_to?(:call)
          filters << filter
        end
      end

      if order
        filters << ->(records:) do
          records = Kit::Store::Services::Table.order_by(list: records, order: order)
          [:ok, records: records]
        end
      end

      if limit.is_a?(Integer)
        limit_value = limit
        limit = ->(records:) { [:ok, records: records.slice(limit_value)] }
      end
      if limit.respond_to?(:call)
        filters << limit
      end

      list = [
        self.method(:_find_all),
        filters,
        self.method(:_clone_as_hash),
      ].flatten

      status, ctx = Kit::Organizer.call({
        list: list,
        ctx: {
          store:       store,
          table_name:  from,
          columns:     select,
        },
      })

      [status, store: store]
    end

    #sig { params(list: T::Array[T::Hash[T.untyped, T.untyped]], order: T::Array[[T.untyped, T.any(Integer,Symbol)]]).returns(T::Array[T::Hash[T.untyped, T.untyped]]) }
    def self.order_by(list:, order: [])
      ordered_list = list.sort do |el1, el2|
        result = 0
        order.each do |attr, direction|
          res = (direction > 0 || direction == :asc) ? (el1[attr] <=> el2[attr]) : (el2[attr] <=> el1[attr])
          res = T.let(res, Integer)
          if res != 0
            result = res
            break
          end
        end

        result
      end

      ordered_list
    end

    def self.find_all(table:)
      [:ok, records: table[:data_list]]
    end


    def self.clone_as_hash(table:, records:, columns:)
      keys = table[:columns_hash].keys

      records_as_hash = records
        .map { |record| [keys, record.deep_dup].transpose.to_h }
        .map { |record| record.slice(*columns) }

      [:ok, records: records_as_hash]
    end

  end
end