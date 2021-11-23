module ArbreCustomComponents
  class PctTag < ActiveAdmin::Component

    builder_method :pct_tag

    def tag_name
      'span'
    end

    def build(*args)
      if args[0]
        code number_to_percentage(args[0] * 100, precision: 2)
      end
    end

  end
end
