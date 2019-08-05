ActiveAdmin.register Kit::Payment::Models::Write::Currency, as: 'Currency', namespace: :kit_payment_admin do
  menu label: 'Currencies'

  actions :all, except: [:new, :edit, :destroy]

  filter :id
  filter :iso4217_alpha
  filter :name
  filter :symbol

  show do
    Kit::Payment::Admin::Tables::Currency.new(self).panel resource
  end

  index do
    Kit::Payment::Admin::Tables::Currency.new(self).index
  end

  csv do
    Kit::Payment::Admin::Tables::Currency.new(self).csv
  end

end
