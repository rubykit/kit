module Kit::Payment::Models::Read
  class Currency < Kit::Payment::Models::ReadRecord
    self.table_name = 'currencies'



    self.allowed_columns = [
      :id,
      :iso4217_alpha,
      :name,
      :minor_unit,
    ]

  end
end
