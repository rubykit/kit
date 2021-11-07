module ArbreCustomComponents

  class DateTag < ActiveAdmin::Component
    builder_method :date_tag

    def tag_name
      'span'
    end

    def default_class_name
      'date_tag'
    end

    def build(*args)
      value  = args[0]
      format = args[1]

      if    format == :date
        format = "%Y-%m-%d %Z"
      elsif format == :time
        format = "%H:%M:%S %Z"
      elsif format.blank?
        format = "%Y-%m-%d %H:%M:%S %Z"
      end

      set_attribute "data-datetime-timezone",  value.strftime("%Z")
      set_attribute "data-datetime-timestamp", value.to_i
      set_attribute "data-datetime-format",    format

      code value.strftime(format)
    end
  end

end