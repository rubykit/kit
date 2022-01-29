class Kit::Domain::Admin::Tables::RequestMetadata < Kit::ActiveAdmin::Table

  def self.attributes_for_all
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

  def self.attributes_for_index
    attributes_for_all.slice(:id, :created_at, :ip, :user_agent, :has_utm)
  end

  def self.attributes_for_limited
    attributes_for_all.slice(:id, :created_at)
  end

  def self.attributes_for_utm
    attributes_for_all.slice(:has_utm, :utm)
  end

  def self.attributes_for_ip
    attributes_for_all.slice(:ip, :country)
  end

  def self.attributes_for_user_agent
    attributes_for_all.slice(:app, :device, :platform, :user_agent)
  end

  def attributes_for_limited;    self.class.attributes_for_limited;    end
  def attributes_for_utm;        self.class.attributes_for_utm;        end
  def attributes_for_ip;         self.class.attributes_for_ip;         end
  def attributes_for_user_agent; self.class.attributes_for_user_agent; end

end
