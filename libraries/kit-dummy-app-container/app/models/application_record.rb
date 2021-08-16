if defined?(ActiveRecord::Railtie)

  class ApplicationRecord < ActiveRecord::Base # rubocop:disable Style/Documentation

    self.abstract_class = true

  end

else

  class ApplicationRecord
  end

end