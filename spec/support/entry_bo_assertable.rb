module EntryBoAssertable

  def assert_entry_with_amount(account, entry, amount)
    expect(entry.amount).to eq amount
    expect(entry.book_date).to eq Date.today
    expect(entry.account).to eq account
  end

end
