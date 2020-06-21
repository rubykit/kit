# Yard serializer to generate non nested documentation.
class Kit::Doc::Yard::FileSerializer < ::YARD::Serializers::FileSystemSerializer

  # Implements the serialized path of a code object.
  #
  # This version produces non nested paths, and removes the `file.` prefix on extras files.
  #
  # ### References
  # - https://github.com/lsegal/yard/blob/master/lib/yard/serializers/file_system_serializer.rb#L50
  def serialized_path(object)
    return object if object.is_a?(String)

    if object.is_a?(::YARD::CodeObjects::ExtraFileObject)
      fspath = [object.name + (extension.empty? ? '' : ".#{ extension }")]
    else
      objname = object != ::YARD::Registry.root ? mapped_name(object) : 'top-level-namespace'
      if object.is_a?(::YARD::CodeObjects::MethodObject)
        objname += '_' + object.scope.to_s[0, 1]
      end

      fspath = [objname.to_s + (extension.empty? ? '' : ".#{ extension }")]
      if object.namespace && object.namespace.path != ''
        fspath.unshift(*object.namespace.path.split(::YARD::CodeObjects::NSEP))
      end
    end

    encode_path_components(*fspath).join('.')
  end

end
