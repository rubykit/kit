require 'kit/dotenv'
require 'dotenv/rails'

module ::Dotenv
  class Railtie < Rails::Railtie

    protected

    def dotenv_files
      if (gem_root = KIT_APP_PATHS['GEM_ROOT'])
        gem_root = Pathname.new(gem_root)
      end

      if (gem_spec_root = KIT_APP_PATHS['GEM_SPEC_ROOT'])
        gem_spec_root = Pathname.new(gem_spec_root)
      end

      list = [
        gem_spec_root&.join(".env.#{Rails.env}.local"),
        gem_root&.join(".env.#{Rails.env}.local"),
        root.join(".env.#{Rails.env}.local"),

        gem_spec_root&.join(".env.#{Rails.env}"),
        gem_root&.join(".env.#{Rails.env}"),
        root.join(".env.#{Rails.env}"),

        gem_spec_root&.join(".env"),
        gem_root&.join(".env"),
        root.join(".env"),
      ]

      list.compact
    end

  end
end
