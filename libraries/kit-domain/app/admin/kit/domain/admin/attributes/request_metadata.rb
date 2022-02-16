class Kit::Domain::Admin::Attributes::RequestMetadata < Kit::Admin::Attributes

  def self.all
    {
      id:         :model_id,
      created_at: nil,

      ip:         :code,
      country:    [:code, ->(_el) { '' }],

      user_agent: :code,
      device:     [:code, ->(el) do
        device = Browser.new(el.user_agent).device
        "#{ device.id } #{ device.name }"
      end,],
      platform:   [:code, ->(el) do
        platform = Browser.new(el.user_agent).platform
        "#{ platform.id } #{ platform.name } #{ platform.version }"
      end,],
      app:        [:code, ->(el) do
        browser = Browser.new(el.user_agent)
        "#{ browser.name } #{ browser.version }"
      end,],

      utm:        :pre_yaml,
      has_utm:    [nil, ->(el) { !el.utm.empty? }],
    }
  end

  def self.index
    all.slice(:id, :created_at, :ip, :user_agent, :has_utm)
  end

  def self.limited
    all.slice(:id, :created_at)
  end

  def self.utm
    all.slice(:has_utm, :utm)
  end

  def self.ip
    all.slice(:ip, :country)
  end

  def self.user_agent
    all.slice(:app, :device, :platform, :user_agent)
  end

end
