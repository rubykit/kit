module ArbreCustomComponents

  class ColorTag < ActiveAdmin::Component
    builder_method :color_tag

    TAG_LIST = {
      stripe:     :blue,
    }

    def tag_name
      'span'
    end

    def build(*args)
      args[0] = args[0].to_s.to_sym
      args[1] = { :class => TAG_LIST[args[0]] || 'grey' }
      status_tag(*args)
    end
  end

end