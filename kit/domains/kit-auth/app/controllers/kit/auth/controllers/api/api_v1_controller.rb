module Kit::Auth::Controllers::Api
  class ApiV1Controller < Kit::Auth::Controllers::ApiController # :nodoc:

    attr_reader :resource

    def api_default_page_size
      if !defined?(@api_default_page_size)
        @api_default_page_size = ENV['API_DEFAULT_PAGE_SIZE'].to_i
        if @api_default_page_size == 0
          @api_default_page_size = 50
        end
      end

      @api_default_page_size
    end

    def api_max_page_size
      if !defined?(@api_max_page_size)
        @api_max_page_size = ENV['API_MAX_PAGE_SIZE'].to_i
        if @api_max_page_size == 0 || @api_max_page_size > 500
          @api_max_page_size = 500
        end
      end

      @api_max_page_size
    end

    def api_page_size(size:)
      size = size.to_i
      if size == 0
        api_default_page_size
      elsif size > api_max_page_size
        api_max_page_size
      else
        size
      end
    end

    def self.afore_action(name, list:)
      list.each do |el|
        self.before_action el, only: [name]
      end
    end

    def paginate(relation:, ordering:)
      page_size       = api_page_size(size: request.params.dig(:page, :size))
      where_arguments = []
      conditions      = nil

      if request.params[:page]
        cursor_str = request.params[:page][:after]
        if !cursor_str.blank?
          cursor_data = Kit::Pagination::Cursor.decode_cursor(cursor_str: cursor_str)
          conditions = Kit::Pagination::Conditions.conditions_for_after(ordering: ordering, cursor_data: cursor_data)
        else
          cursor_str = request.params[:page][:before]
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

    def load_resource!(model:, param:, column: nil)
      param    = param.to_sym
      column ||= param
      column   = column.to_sym

      value    = params[param]

      if !value.blank?
        @resource = model.find_by({
          column => value,
        })
      end

      if !column || value.blank? || !@resource
        render_404(model: model, id: id)
      end
    end

    def find_belongs_to_field(parent:, child:)
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

    def require_current_user!
      resolve_current_user
      return if current_user

      status_code = 401
      errors = [
        {
          status: status_code.to_s,
          code:   "unauthorized",
          title:  "Unauthorized",
          detail: "You need to authenticate in order to access this ressource.",
        },
      ]

      render({
        status:         status_code,
        jsonapi_errors: errors,
      })
    end

    def require_belongs_to!(parent:, child:)
      return if parent == child

      field = find_belongs_to_field(parent: parent, child: child)

      return if field && child.send(field) == parent.id

      status_code = 403
      errors = [
        {
          status: status_code.to_s,
          code:   "forbidden",
          title:  "Forbidden",
          detail: "You do not have the authorization to perform this action.",
        },
      ]

      render({
        status:         status_code,
        jsonapi_errors: errors,
      })
    end

    def render_404(model:, id:)
      status_code = 404
      model_name  = model.name.demodulize

      errors = [
        {
          status: status_code.to_s,
          code:   "not-found",
          title:  "#{model_name} Not Found",
          detail: "#{model_name} #{id} is not available on this server",
        },
      ]

      render({
        status:         status_code,
        jsonapi_errors: errors,
      })
    end

    def render_404(model:, id:)
      status_code = 404
      model_name  = model.name.demodulize

      errors = [
        {
          id:     id.to_s,
          status: status_code.to_s,
          code:   "not-found",
          title:  "User Not Found",
          detail: "User #{id} is not available on this server",
        },
      ]

      render({
        status:         status_code,
        jsonapi_errors: errors,
      })
    end

  end
end
