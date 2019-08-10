module Kit::Auth::Cells::Users
  class DeviceCell < Kit::Auth::Cells::Cell
    def show
      render
    end

    def user_agent_string
      model.dig(:user_request_metadata, :user_agent)
    end

    def token
      puts model
      model[:oauth_access_token]
    end

    def app
      user_agent.name
    end

    def device
      name = user_agent&.device&.name
      if name == 'Unknown'
        name = nil
      end

      if !name
        name = user_agent&.platform&.name
      end

      if name == "Macintosh"
        name = "Mac"
      end

      name || 'Unknown'
    end

    def country
      model[:country]
    end

    def country_name
      country.dig(:name)
    end

    def last_date
      model.dig(:user_request_metadata, :created_at)&.strftime('%A %F')
    end


    def user_agent
      @user_agent ||= user_agent_string ? Browser.new(user_agent_string) : nil
    end

  end
end