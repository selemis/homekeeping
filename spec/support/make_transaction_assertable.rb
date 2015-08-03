module MakeTransactionAssertable

  def create_transaction_type(values)
    values[:type].new do |tt|
      tt.from = values[:from_account]
      tt.to = values[:to_account]
      tt.date = Date.today
      tt.amount = values[:amount]
    end
  end

  def assert_payment(values)
    trans = values[:transaction]
    entry1 = trans.accounting_entries.select { |entry| entry.account == values[:from_account] }.first
    entry2 = trans.accounting_entries.select { |entry| entry.account == values[:to_account] }.first
    expect(trans.valid?).to be_true
    expect(trans.accounting_entries.size).to eq 2
    expect(entry1.amount).to eq values[:from_amount]
    expect(entry2.amount).to eq values[:to_amount]
  end

end
