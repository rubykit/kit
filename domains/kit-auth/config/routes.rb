Kit::Auth::Engine.routes.draw do

  Kit::Auth::Admin.routes(self)

  #use_doorkeeper

  #Rails.application.routes.draw do
  #  use_doorkeeper # scope: 'api/v1/oauth'
  #end

end
