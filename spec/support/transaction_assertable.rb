module TransactionAssertable

  def assert_transaction_placement(values)
    expect(values[:credit_account].accounting_entries.size).to eq 1
    expect(values[:debit_account].accounting_entries.size).to eq 1
    expect(values[:credit_account].credit).to eq values[:credit]
    expect(values[:debit_account].debit).to eq values[:debit]
  end
  
  def assert_account_from_db(account)
    db_account = Account.find_by(name: account.name)
    expect(db_account.name).to eq account.name
    expect(db_account.accounting_entries.size).to eq account.accounting_entries.size
    expect(db_account.debit).to eq account.debit
    expect(db_account.credit).to eq account.credit
  end

end

