module Kit::Config # rubocop:disable Style/Documentation

  def self.[](key)
    if key == :ENV_TYPE
      [ENV['ENV'], ENV['RAILS_ENV']].compact.uniq.map(&:to_sym)
    else
      ENV[key.to_s]
    end
  end

end
