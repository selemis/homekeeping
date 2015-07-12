require 'spec_helper'

describe Account do

  it 'has a name' do
    account = Account.new
    account.name='Cash'
    expect(account.name).to eq 'Cash'
  end

  it 'requires a name' do
    account = Account.new

    account.valid?

    expect(account.errors[:name].any?).to be_true
  end

  it 'is valid with example attributes' do
    account = Account.new(account_attributes)

    expect(account.valid?).to be_true
  end

  it 'has entries' do
    accounting_entry = AccountingEntry.new(accounting_entry_attributes)
    account = Account.new
    account.accounting_entries << accounting_entry

    expect(account.accounting_entries.size).to eq 1
    expect(account.accounting_entries.first).to eq accounting_entry

  end

  it 'has a balance' do
    entry1 = AccountingEntry.new({book_date: Date.strptime('01-01-2015', '%d-%m-%Y'), amount: 100.50})
    entry2 = AccountingEntry.new({book_date: Date.strptime('01-01-2015', '%d-%m-%Y'), amount: -20.50})
    entry3 = AccountingEntry.new({book_date: Date.strptime('02-01-2015', '%d-%m-%Y'), amount: 10})
    entry4 = AccountingEntry.new({book_date: Date.strptime('03-01-2015', '%d-%m-%Y'), amount: -30})
    entry5 = AccountingEntry.new({book_date: Date.strptime('04-01-2015', '%d-%m-%Y'), amount: 40.20})
    account = Account.new
    account.accounting_entries << entry1 << entry2 << entry3 << entry4 << entry5

    expect(account.balance).to eq 100.20
  end

  it 'has a zero balance if it has no entries' do
    account = Account.new(account_attributes)
    expect(account.balance).to eq 0
  end

  it 'calculates a balance until a date'

  it 'has credits'

  it 'calculates the credits until a date'

  it 'has debits'

  it 'calculates the debits until a date'

  it 'can have a parent account'

end