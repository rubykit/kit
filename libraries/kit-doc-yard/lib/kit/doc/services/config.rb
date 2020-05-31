# Singleton service to hold plugin config.
module Kit::Doc::Services::Config
  class << self

    attr_accessor :config

=begin
    def config=(val)
      @config = val
    end

    def config
      @config
    end
=end

  end
end
