require 'spec_helper'

describe AccountingEntry do

  require 'spec_helper'

  describe AccountingEntry do

    context 'having a valid accounting entry' do

      before do
        @accounting_entry = AccountingEntry.new(accounting_entry_attributes)
      end

      it 'has a booking date' do
        expect(@accounting_entry.book_date).to eq accounting_entry_attributes[:book_date]
      end

      it 'has an amount' do
        expect(@accounting_entry.amount).to eq accounting_entry_attributes[:amount]
      end

      it 'is valid with example attributes' do
        expect(@accounting_entry.valid?).to eq true
      end

    end

    it 'it requires a booking date' do
      accounting_entry = AccountingEntry.new

      accounting_entry.valid?

      expect(accounting_entry.errors[:book_date].any?).to eq(true)
    end

    it 'is requires an amount' do
      accounting_entry = AccountingEntry.new

      accounting_entry.valid?

      expect(accounting_entry.errors[:amount].any?).to eq(true)
    end
    
    it 'can belong to an account' do
      account = Account.new(account_attributes)
      entry = AccountingEntry.new(accounting_entry_attributes)
      account.accounting_entries << entry

      expect(entry.account).to eq account
    end

    it 'is credit accounting entry if it belongs to an Assets account and the amount is negative' do
      account = Account.new(name: 'Cash', category: 'Assets')
      entry = AccountingEntry.new(accounting_entry_attributes(amount: -100))
      entry.account = account

      expect(entry.credit?).to be_true
      expect(entry.debit?).to be_false
    end

    it 'is debit accounting entry if it belongs to an Assets account and the amount is positive' do
      account = Account.new(name: 'Cash', category: 'Assets')
      entry = AccountingEntry.new(accounting_entry_attributes(amount: 100))
      entry.account = account

      expect(entry.credit?).to be_false
      expect(entry.debit?).to be_true
    end

    it 'is credit accounting entry if it belongs to an Expenses account and the amount is negative' do
      account = Account.new(name: 'Groceries', category: 'Expenses')
      entry = AccountingEntry.new(accounting_entry_attributes(amount: -100))
      entry.account = account

      expect(entry.credit?).to be_true
      expect(entry.debit?).to be_false
    end
    
    it 'is debit accounting entry if it belongs to an Expenses account and the amount is positive' do
      account = Account.new(name: 'Groceries', category: 'Expenses')
      entry = AccountingEntry.new(accounting_entry_attributes(amount: 100))
      entry.account = account

      expect(entry.credit?).to be_false
      expect(entry.debit?).to be_true
    end

    it 'is credit accounting entry if it belongs to an Liabilities account and the amount is positive' do
      account = Account.new(name: 'Bank Loan', category: 'Liabilities')
      entry = AccountingEntry.new(accounting_entry_attributes(amount: 100))
      entry.account = account

      expect(entry.credit?).to be_true
      expect(entry.debit?).to be_false
    end

    it 'is debit accounting entry if it belongs to an Liabilities account and the amount is negative' do
      account = Account.new(name: 'Bank Loan', category: 'Liabilities')
      entry = AccountingEntry.new(accounting_entry_attributes(amount: -100))
      entry.account = account

      expect(entry.credit?).to be_false
      expect(entry.debit?).to be_true
    end

    it 'is credit accounting entry if it belongs to an Equity account and the amount is positive' do
      account = Account.new(name: 'Parents', category: 'Equity')
      entry = AccountingEntry.new(accounting_entry_attributes(amount: 100))
      entry.account = account

      expect(entry.credit?).to be_true
      expect(entry.debit?).to be_false
    end

    it 'is debit accounting entry if it belongs to an Equity account and the amount is negative' do
      account = Account.new(name: 'Parents', category: 'Equity')
      entry = AccountingEntry.new(accounting_entry_attributes(amount: -100))
      entry.account = account

      expect(entry.credit?).to be_false
      expect(entry.debit?).to be_true
    end

    it 'is credit accounting entry if it belongs to a Revenue account and the amount is positive' do
      account = Account.new(name: 'Salary', category: 'Revenue')
      entry = AccountingEntry.new(accounting_entry_attributes(amount: 100))
      entry.account = account

      expect(entry.credit?).to be_true
      expect(entry.debit?).to be_false
    end

    it 'is debit accounting entry if it belongs to an Revenue account and the amount is negative' do
      account = Account.new(name: 'Salary', category: 'Revenue')
      entry = AccountingEntry.new(accounting_entry_attributes(amount: -100))
      entry.account = account

      expect(entry.credit?).to be_false
      expect(entry.debit?).to be_true
    end

  end

end
