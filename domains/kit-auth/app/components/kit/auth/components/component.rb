module Kit::Auth::Components
  class Component < Kit::Domain::Components::Component

    attr_reader :errors_list

    def initialize(errors_list: [], **)
      super
      @errors_list = errors_list
    end

    def local_render(router_request: nil, &block)
      controller     = router_request.rails[:controller]
      lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
      view           = ActionView::Base.new(lookup_context, {}, controller)

      self.render_in(view)
    end

  end
end
