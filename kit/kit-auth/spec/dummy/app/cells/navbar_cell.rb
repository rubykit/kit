class NavbarCell < Cell::ViewModel
  # NOTE: For main_app to be available
  include ::Rails.application.routes.mounted_helpers

  def show
    render
  end
end