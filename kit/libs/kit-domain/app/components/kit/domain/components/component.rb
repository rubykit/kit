class Kit::Domain::Components::Component < ActionView::Component
  attr_accessor :id

  def component_class_name
    @component_class_name ||= self.class.component_class_name
  end

  def random_id(lid = id)
    @random_id ||= "#{lid.underscore}_#{SecureRandom.hex(4)}"
  end

  class << self

    def component_class_name
      filename                   = self.instance_method(:initialize).source_location[0]
      filename_without_extension = filename[0..-(File.extname(filename).length + 1)]

      name = self.name.underscore.split('components/')[1].downcase.dasherize.gsub('/', '_')

      "component_#{name}"
    end

    def template_file_path
      raise NotImplementedError.new("#{self} must implement #initialize.") unless self.instance_method(:initialize).owner == self

      filename                   = self.instance_method(:initialize).source_location[0]
      filename_without_extension = filename[0..-(File.extname(filename).length + 1)]

      # NOTE: added this
      template_files = Dir["#{filename_without_extension}/template*"]
      if template_files.size == 1
        return template_files[0]
      end

      sibling_files = Dir["#{filename_without_extension}.*"] - [filename]

      if sibling_files.length > 1
        raise StandardError.new("More than one template found for #{self}. There can only be one sidecar template file per component.")
      end

      if sibling_files.length == 0
        raise NotImplementedError.new(
          "Could not find a template for #{self}. Either define a .template method or add a sidecar template file."
        )
      end

      sibling_files[0]
    end

  end
end