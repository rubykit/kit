module Kit::Auth::Endpoints::Api::Aliases::Api

  def self.load_resource!(router_conn:, model:, param: :resource_id, column: :id)
    param    = param.to_sym
    column ||= param
    column   = column.to_sym
    value    = router_conn.request[:params][param]

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

  def self.render_unauthorized
    status_code = 401

    Kit::Domain::Endpoints::Http.render_jsonapi_errors(
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

    Kit::Domain::Endpoints::Http.render_jsonapi_errors(
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

    Kit::Domain::Endpoints::Http.render_jsonapi_errors(
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

end
