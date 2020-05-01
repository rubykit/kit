module Yard::Kit::Services::Properties

  # Returns object `tags` + some ruby properties
  def self.object_properties(item:, verifier_runner:, silence_list: [:return, :param])
    list = []

    silence_list ||= []

    item.tags.each do |tag|
      tag_name  = tag.tag_name.to_sym
      tag_value = tag.text

      next if silence_list.include?(tag_name)

      if tag_name == :deprecated
        tag_value = true
      end

      list << { group: :tag, name: tag_name, value: tag_value }
    end

    visibility = item.respond_to?(:visibility) ? item.visibility : nil
    if visibility != :public
      list << { group: :ruby, name: :visibility, value: visibility }
    end

    constructor = item.respond_to?(:constructor?) ? item.constructor? : nil
    if constructor
      list << { group: :ruby, name: :constructor, value: true }
    end

    abstract = item.has_tag?(:abstract)
    if abstract
      list << { group: :ruby, name: :abstract, value: true }
    end

    read_write_info = (item.respond_to?(:attr_info) && !item.is_a?(::YARD::CodeObjects::ConstantObject)) ? item.attr_info : nil
    if read_write_info
      readonly  = !verifier_runner.call([read_write_info[:read]].compact).empty? && verifier_runner.call([read_write_info[:write]].compact).empty?
      if readonly
      list << { group: :ruby, name: :readonly, value: true }
      end

      writeonly = !verifier_runner.call([read_write_info[:write]].compact).empty? && verifier_runner.call([read_write_info[:read]].compact).empty?
      if writeonly
      list << { group: :ruby, name: :writeonly, value: true }
      end
    end

    list
  end

  # Get a list of data-* attributes 
  def self.object_html_data_properties(item:, verifier_runner:)
    list = object_properties(item: item, verifier_runner: verifier_runner)

    list
      .map { |data| ["data-#{ data[:group] }-#{ data[:name] }", data[:value].to_s] }
      .to_h
  end

  # Return `true` if at least one item in the list is considered a `private API`
  def self.has_private_apis?(list:)
    list.each do |item|
      if item.has_tag?(:api) && item.tag(:api).text == 'private'
        return true
      end

      visibility = item.respond_to?(:visibility) ? item.visibility : nil
      if visibility != :public
        return true
      end
    end

    false
  end

end
