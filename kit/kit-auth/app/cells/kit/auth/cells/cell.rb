module Kit::Auth::Cells
  class Cell < Cell::ViewModel
    abstract!

    include ::Rails.application.routes.mounted_helpers
    include ActionView::Helpers::FormHelper
    include SimpleForm::ActionViewExtensions::FormHelper

    self.view_paths = ["#{Kit::Auth::Engine.root}/app/cells/"]
  end
end