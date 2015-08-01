def accounting_entry_attributes(overrides={})
  {
      book_date: Date.today,
      amount: 12.34
  }.merge(overrides)
end

def account_attributes(overrides={})
  {name: 'Cash',
   category: 'Assets'}.merge(overrides)
end
