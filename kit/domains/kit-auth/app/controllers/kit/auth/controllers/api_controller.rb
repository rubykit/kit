module Kit::Auth::Controllers
  # NOTE: This is a little backward: we inherit from the engine container controller in order to display the layout
  class ApiController < ::ApiController
    #include Kit::Auth::Controllers::Api::Concerns::CurrentUser

  end
end
