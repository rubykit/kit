# HTTP request adapter helpers.
module Kit::Domain::Endpoints::Http::Web

  def self.require_belongs_to!(router_conn:, parent:, child:)
    return [:ok] if parent == child

    field = find_belongs_to_field(parent: parent, child: child)

    return [:ok] if field && child.send(field) == parent.id

    redirect_to_forbidden(router_conn: router_conn)
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

  def self.redirect_to_forbidden(router_conn:, redirect_url: nil)
    redirect_url ||= Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|errors|forbidden')

    Kit::Domain::Endpoints::Http.redirect_to(
      router_conn: router_conn,
      location:    redirect_url,
      flash:       {
        error: I18n.t('kit.auth.notifications.errors.forbidden'),
      },
    )
  end

end
