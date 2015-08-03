module MakePaymemntAssertable

  def create_expense_payment_transaction(values)
    pay = values[:type].new do |p|
      p.from = values[:from_account]
      p.to = values[:to_account]
      p.date = Date.today
      p.amount = values[:amount]
    end
  end

  def assert_payment(values)
    trans = values[:transaction]
    entry1 = trans.accounting_entries.select { |entry| entry.account == values[:first_account] }.first
    entry2 = trans.accounting_entries.select { |entry| entry.account == values[:second_account] }.first
    expect(trans.valid?).to be_true
    expect(trans.accounting_entries.size).to eq 2
    expect(entry1.amount).to eq values[:first_amount]
    expect(entry2.amount).to eq values[:second_amount]
  end

end
