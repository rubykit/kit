class YARD::CLI::YardocOptions # rubocop:disable Style/Documentation

  # Add Kit version of the FileSerializer.
  default_attr :serializer, -> { Kit::Doc::Yard::FileSerializer.new }

end
