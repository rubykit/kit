module Kit::Auth::Controllers
  module Api

    def self.serializers
      {
        'Kit::Auth::Models::Read::User':              Kit::Auth::Serializers::User,
        'Kit::Auth::Models::Write::User':             Kit::Auth::Serializers::User,
        'Kit::Auth::Models::Read::OauthAccessToken':  Kit::Auth::Serializers::AccessToken,
        'Kit::Auth::Models::Write::OauthAccessToken': Kit::Auth::Serializers::AccessToken,
      }
    end

    def self.load_resource!(router_request:, model:, param: :resource_id, column: :id)
      param    = param.to_sym
      column ||= param
      column   = column.to_sym
      value    = router_request.params[param]

      if column && !value.blank?
        resource = model.find_by({ column => value })
        if resource
          return [:ok, resource: resource]
        end
      end

      render_not_found(model: model, id: value)
    end

    def self.require_belongs_to!(parent:, child:)
      return [:ok] if parent == child

      field = find_belongs_to_field(parent: parent, child: child)

      return [:ok] if field && child.send(field) == parent.id

      render_forbidden
    end

    def self.render_unauthorized
      status_code = 401

      Kit::Router::Controllers::Http.render_jsonapi_errors(
        status:    status_code,
        resources: [
          {
            status: status_code.to_s,
            code:   'unauthorized',
            title:  'Unauthorized',
            detail: 'You need to authenticate in order to access this ressource.',
          },
        ],
      )
    end

    def self.render_forbidden
      status_code = 403

      Kit::Router::Controllers::Http.render_jsonapi_errors(
        status:    status_code,
        resources: [
          {
            status: status_code.to_s,
            code:   'forbidden',
            title:  'Forbidden',
            detail: 'You do not have the authorization to perform this action.',
          },
        ],
      )
    end

    def self.render_not_found(model:, id:)
      status_code = 404
      model_name  = model.name.demodulize

      Kit::Router::Controllers::Http.render_jsonapi_errors(
        status:    status_code,
        resources: [
          {
            status: status_code.to_s,
            code:   'not-found',
            title:  "#{ model_name } Not Found",
            detail: "#{ model_name } #{ id } is not available on this server",
          },
        ],
      )
    end

    def self.find_belongs_to_field(parent:, child:)
      child_class             = child.class
      parent_class_read_name  = parent.class.to_read_class.name
      parent_class_write_name = parent.class.to_write_class.name

      field = nil
      child_class.reflect_on_all_associations(:belongs_to).each do |association|
        if association.class_name.in?([parent_class_read_name, parent_class_write_name])
          field = association.foreign_key
          break
        end
      end

      field
    end

    def self.api_default_page_size
      if !defined?(@api_default_page_size)
        @api_default_page_size = ENV['API_DEFAULT_PAGE_SIZE'].to_i
        if @api_default_page_size == 0
          @api_default_page_size = 50
        end
      end

      @api_default_page_size
    end

    def self.api_max_page_size
      if !defined?(@api_max_page_size)
        @api_max_page_size = ENV['API_MAX_PAGE_SIZE'].to_i
        if @api_max_page_size == 0 || @api_max_page_size > 500
          @api_max_page_size = 500
        end
      end

      @api_max_page_size
    end

    def self.api_page_size(size:)
      size = size.to_i
      if size == 0
        api_default_page_size
      elsif size > api_max_page_size
        api_max_page_size
      else
        size
      end
    end

    def self.paginate(router_request:, relation:, ordering:)
      page_size       = api_page_size(size: router_request.params.dig(:page, :size))
      where_arguments = []
      conditions      = nil

      if router_request.params[:page]
        cursor_str = router_request.params[:page][:after]
        if !cursor_str.blank?
          cursor_data = Kit::Pagination::Cursor.decode_cursor(cursor_str: cursor_str)
          conditions = Kit::Pagination::Conditions.conditions_for_after(ordering: ordering, cursor_data: cursor_data)
        else
          cursor_str = router_request.params[:page][:before]
          if !cursor_str.blank?
            cursor_data = Kit::Pagination::Cursor.decode_cursor(cursor_str: cursor_str)
            conditions = Kit::Pagination::Conditions.conditions_for_before(ordering: ordering, cursor_data: cursor_data)
          end
        end

        if conditions
          where_arguments = Kit::Pagination::ActiveRecord.to_where_arguments(conditions: conditions)
        end
      end

      if where_arguments.size > 0
        relation = relation
          .where(*where_arguments)
      end

      relation
        .order(*Kit::Pagination::ActiveRecord.to_order_arguments(ordering: ordering))
        .limit(page_size)
    end

    def self.get_pagination_parameters(collection:, ordering:)
      params = { next: {}, prev: {} }

      list = [
        [:prev,  0, :before],
        [:next, -1, :after],
      ]

      # NOTE: implicit dependency, should this be parametized?
      page_size = router_request.params.dig(:page, :size).to_i
      if page_size > 0
        page_size = api_page_size(size: page_size)
      end

      list.each do |el|
        id, offset, param_name = el

        cursor_data = Kit::Pagination::Cursor.cursor_data_for_element(ordering: ordering, element: collection[offset])
        token       = Kit::Pagination::Cursor.encode_cursor(cursor_data: cursor_data)

        if token
          params[id][:page] ||= {}
          params[id][:page][param_name] = token
        end

        if page_size > 0
          params[id][:page] ||= {}
          params[id][:page][:size] = page_size
        end
      end

      params
    end

  end
end
