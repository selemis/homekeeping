def accounting_entry_attributes(overrides={})
  {
      book_date: Date.today,
      amount: 12.34
  }.merge(overrides)
end