require_relative 'base_table'

class Kit::Auth::Admin::Tables::UserRequestMetadata < Kit::Auth::Admin::Tables::BaseTable

  def attributes_for_all
    {
      id:         :model_id,
      created_at: nil,

      user:       :model_verbose,

      ip:         :code,
      country:    [:code, ->(el) { '' }],

      user_agent: :code,
      device:    [:code, ->(el) do
        device = Browser.new(el.user_agent).device
        "#{device.id} #{device.name}"
      end],
      platform:    [:code, ->(el) do
        platform = Browser.new(el.user_agent).platform
        "#{platform.id} #{platform.name} #{platform.version}"
      end],
      app:    [:code, ->(el) do
        browser = Browser.new(el.user_agent)
        "#{browser.name} #{browser.version}"
      end],

      utm:        :pre_yaml,
      has_utm:    [nil, ->(el) { !el.utm.empty? }],
    }
  end

  def attributes_for_index
    attributes_for_all.slice(:id, :created_at, :user, :ip, :user_agent, :has_utm)
  end

  def attributes_for_list
    attributes_for_index
  end

  def attributes_for_show
    attributes_for_all
  end

  def attributes_for_limited
    attributes_for_all.slice(:id, :created_at)
  end

  def attributes_for_utm
    attributes_for_all.slice(:has_utm, :utm)
  end

  def attributes_for_ip
    attributes_for_all.slice(:ip, :country)
  end

  def attributes_for_user_agent
    attributes_for_all.slice(:app, :device, :platform, :user_agent)
  end

end