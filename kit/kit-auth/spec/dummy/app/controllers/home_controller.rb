class HomeController < ApplicationController

  def index
    puts cookies.encrypted[:access_token]
    redirect_to '/non-existing-home.html'
  end

end