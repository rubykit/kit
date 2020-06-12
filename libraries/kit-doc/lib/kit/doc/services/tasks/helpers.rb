require 'rubygems'
require 'fileutils'
require 'git'

# Utilities methods to help in rake tasks.
module Kit::Doc::Services::Tasks::Helpers

  # Expand paths.
  def self.resolve_files(hash:)
    hash
      .map do |lib_path, data|
        (data[:include] || []).map { |path| Dir[File.join(lib_path, path)] }
      end
      .flatten
  end

  # Return a display helper that compute the needed css padding based on nesting, ignoring `hide`.
  def self.display_css_padding(hide: nil)
    ->(name) do
      #size = name.gsub(text, '').gsub(%r{^::}, '').scan('::').size
      if hide
        name = name.gsub(hide, '')
      end
      size = name.scan('::').size
      ["#{ (size > 0) ? "sidebar-pl-#{ size }" : '' }"]
    end
  end

  # Return a display helper that return last object name
  def self.display_last_name
    ->(name) { name.split('::')[-1] }
  end

end
