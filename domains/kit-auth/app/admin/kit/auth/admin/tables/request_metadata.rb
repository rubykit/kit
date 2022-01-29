class Kit::Auth::Admin::Tables::RequestMetadata < Kit::ActiveAdmin::Table

  def self.attributes_for_all
    Kit::Domain::Admin::Tables::RequestMetadata.attributes_for_all.merge(
      user: :model_verbose,
    )
  end

  def self.attributes_for_index
    attributes_for_all.slice(:id, :created_at, :user, :ip, :user_agent, :has_utm)
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
