module Helpers::Applications

  def app_web
    Kit::Auth::Actions::Applications::LoadWeb.call[1][:application]
  end

  def app_api
    Kit::Auth::Actions::Applications::LoadApi.call[1][:application]
  end

end
