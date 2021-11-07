module ArbreCustomComponents
  class AmountTag < ActiveAdmin::Component

    builder_method :amount_tag

    def tag_name
      'span'
    end

    def build(*args)
      if args[0]
        code number_to_currency(args[0], precision: 2)
      end
    end

  end
end
