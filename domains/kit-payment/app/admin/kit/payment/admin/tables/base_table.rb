module Kit::Payment::Admin::Tables
  class BaseTable < Kit::ActiveAdmin::Table
    include Kit::Payment::Routes

  end
end