module Kit::Auth::Components
  class Component < Kit::Domain::Components::Component

    attr_reader :errors_list

    def initialize(errors_list: [], **)
      super
      @errors_list = errors_list
    end

    # TODO: assess if there is a collision with `render`, otherwise use that!
    def local_render(view_context = nil, &block)
      self.class.compile
      if block_given?
        @content = view_context.capture(&block)
      end
      call
    end

  end
end
