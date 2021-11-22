class Kit::Domain::Components::Specs::LinkToComponent < Kit::ViewComponents::Components::BaseComponent

  def params
    router_conn[:params]
  end

  def url
    params[:url]
  end

  def method
    params[:method]
  end

  def csrf_token
    router_conn.request[:http][:csrf_token]
  end

  def csrf_param
    'authenticity_token'
  end

end
