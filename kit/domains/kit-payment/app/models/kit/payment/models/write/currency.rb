module Kit::Payment::Models::Write
  class Currency < Kit::Payment::Models::WriteRecord
    self.table_name = 'currencies'



    self.whitelisted_columns = [
      :id,
      :iso4217_alpha,
      :name,
      :minor_unit,
    ]

  end
end
