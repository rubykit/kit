class Kit::Auth::Components::Users::DeviceComponent < Kit::Auth::Components::Component

  attr_reader :model

  def initialize(model:)
    super
    @model = model
  end

  def user_agent_string
    model&.dig(:request_metadata, :user_agent)
  end

  def token
    model[:access_token]
  end

  def app
    user_agent&.name
  end

  def device
    name = user_agent&.device&.name
    if name == 'Unknown'
      name = nil
    end

    if !name
      name = user_agent&.platform&.name
    end

    if name == 'Macintosh'
      name = 'Mac'
    end

    name || 'Unknown'
  end

  def country
    model[:country]
  end

  def country_name
    country&.dig(:name)
  end

  def last_date
    model&.dig(:request_metadata, :created_at)&.strftime('%A %F')
  end

  def user_agent
    @user_agent ||= user_agent_string ? ::Browser.new(user_agent_string) : nil
  end

end
