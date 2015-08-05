require 'spec_helper'

describe AccountingTransaction do

  it 'has entries' do
    trans = AccountingTransaction.new
    entry1 = AccountingEntry.new(accounting_entry_attributes({amount: 100}))
    entry2 = AccountingEntry.new(accounting_entry_attributes({amount: -100}))
    trans.accounting_entries << entry1 << entry2

    expect(trans.accounting_entries.size).to eq 2
    expect(trans.accounting_entries.first).to eq entry1
    expect(trans.accounting_entries.second).to eq entry2
  end

  it 'has a book date' do
    trans = AccountingTransaction.new
    trans.book_date = Date.today

    expect(trans.book_date).to eq Date.today
  end


  context 'given a new transaction' do

    before do
      @trans = AccountingTransaction.new
      @trans.valid?
    end

    it 'requires a booking date' do
      expect(@trans.errors[:book_date].any?).to eq(true)
    end

    it ' when checking for validation then an error occurs because it has less than 2 accounting entries' do
      expect(@trans.errors[:accounting_entries_size].any?).to eq(true)
    end

  end

  context 'given a transaction with one accounting entry' do

    before do
      @trans = AccountingTransaction.new
      entry = AccountingEntry.new(accounting_entry_attributes)
      entry.account = Account.new(account_attributes)
      @trans.accounting_entries << entry
    end

    it ' when checking for validation then an error occurs because it has less than 2 accounting entries' do
      @trans.valid?

      expect(@trans.errors[:accounting_entries_size].any?).to eq(true)
    end

    context 'given a transaction with two accounting entries' do

      before do
        entry = AccountingEntry.new(accounting_entry_attributes({amount: accounting_entry_attributes[:amount] * -1}))
        entry.account = Account.new(account_attributes)
        @trans.accounting_entries << entry
      end

      it ' when checking validation, then it raises no errors for accounting entries size' do
        @trans.valid?

        expect(@trans.errors[:accounting_entries_size].any?).to eq(false)
      end

    end

  end

  context 'given a transaction with one credit entry' do

    before do
      @transaction = AccountingTransaction.new
      @transaction.book_date = Date.today
      savings_account = Account.new(name: 'Savings Account', category: 'Assets')
      credit_entry = AccountingEntry.new(book_date: Date.today, amount: -100)
      credit_entry.account = savings_account
      @transaction.accounting_entries << credit_entry
    end

    context 'and given one debit entry of the same amount' do

      before do
        @salary = Account.new(name: 'Cash', category: 'Assets')
        debit_entry = AccountingEntry.new(book_date: Date.today, amount: 100)
        debit_entry.account = @salary
        @transaction.accounting_entries << debit_entry
      end

      it 'when checking for validation, then it requires the credits to be equal to debits' do
        @transaction.valid?

        expect(@transaction.errors[:credits_debits].any?).to be_false
      end

      it 'when adding another entry and checking for validation then an error occurs because credits do not equal to debits' do
        entry = AccountingEntry.new(book_date: Date.today, amount: -10)
        entry.account = @salary
        @transaction.accounting_entries << entry

        @transaction.valid?

        expect(@transaction.errors[:credits_debits].any?).to be_true
      end

    end

    context 'and given one debit entry of the same amount and different book date' do

      before do
        @salary = Account.new(name: 'Cash', category: 'Assets')
        debit_entry = AccountingEntry.new(book_date: Date.parse('2015-01-01'), amount: 100)
        debit_entry.account = @salary
        @transaction.accounting_entries << debit_entry
      end

      it 'when checking for validation then an error occurs because the booking date of all the entries are not the same' do
        expect(@transaction.valid?).to be_false
        expect(@transaction.errors[:entries_book_date].any?).to be_true
      end

    end

  end

end

