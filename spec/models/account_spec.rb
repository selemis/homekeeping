require 'spec_helper'
require 'services/credit_calculator'
require 'services/debit_calculator'

include AccountAssertable

def date_from(string_format)
  Date.strptime(string_format, '%d-%m-%Y')
end

describe Account do

  context 'Given an account' do

    before do
      @account = Account.new(account_attributes)
    end

    it 'has a name' do
      expect(@account.name).to eq 'Cash'
    end

    it 'is valid with example attributes' do
      @account.valid?
      expect(@account.valid?).to be_true
    end

    it 'has a zero balance if it has no entries' do
      expect(@account.balance).to eq 0
    end

    it 'has a zero credit if it has no entries' do
      creditor = CreditCalculator.new
      expect(creditor.calculate_credit(@account)).to eq 0
    end

    it 'has a zero debit if it has no entries' do
      debitor = DebitCalculator.new  
      expect(debitor.calculate_debit(@account)).to eq 0
    end

    it 'has a zero credit if the account has only debits' do
      @account.accounting_entries << AccountingEntry.new(accounting_entry_attributes)
      debitor = DebitCalculator.new  
      expect(debitor.calculate_debit(@account)).to eq accounting_entry_attributes[:amount]


      #expect(@account.calculate_debit).to eq accounting_entry_attributes[:amount]
      creditor = CreditCalculator.new
      expect(creditor.calculate_credit(@account)).to eq 0
    end

    it 'has a zero debit if the account has only credits' do
      @account.accounting_entries << AccountingEntry.new(accounting_entry_attributes({amount: -50}))

      creditor = CreditCalculator.new
      expect(creditor.calculate_credit(@account)).to eq -50

      debitor = DebitCalculator.new  
      expect(debitor.calculate_debit(@account)).to eq 0
      #expect(@account.calculate_debit).to eq 0
    end

  end

  it 'requires a name' do
    account = Account.new

    account.valid?

    expect(account.errors[:name].any?).to be_true
  end

  it 'has entries' do
    accounting_entry = AccountingEntry.new(accounting_entry_attributes)
    account = Account.new

    account.accounting_entries << accounting_entry

    expect(account.accounting_entries.size).to eq 1
    expect(account.accounting_entries.first).to eq accounting_entry
  end

  it 'must have a category' do
    account = Account.new({name: 'Cash'})

    account.valid?

    expect(account.errors[:category].any?).to eq(true)
  end

  it 'requires a account type that is in an approved list' do
    account_types = Account::CATEGORIES
    account_types.each do |category|
      account = Account.new(account_attributes(category: category))

      account.valid?

      expect(account.errors[:type].any?).to eq(false)
    end
  end

  it 'rejects any account type that is not in the approved list' do
    account_types = %w[Abc Cash Car]
    account_types.each do |category|
      account = Account.new(account_attributes(category: category))

      account.valid?
      
      expect(account.errors[:category].any?).to eq(true)
    end
  end

  context 'Having an account with entries' do

    before do
      @entry1 = AccountingEntry.new({book_date: date_from('01-01-2015'), amount: 100.50})
      @entry2 = AccountingEntry.new({book_date: date_from('01-01-2015'), amount: -20.50})
      @entry3 = AccountingEntry.new({book_date: date_from('02-01-2015'), amount: 10})
      @entry4 = AccountingEntry.new({book_date: date_from('03-01-2015'), amount: -30})
      @entry5 = AccountingEntry.new({book_date: date_from('04-01-2015'), amount: 40.20})
      @account = Account.new(account_attributes)
      @account.accounting_entries << @entry1 << @entry2 << @entry3 << @entry4 << @entry5
    end

    it 'has a balance' do
      expect(@account.balance).to eq 100.20
    end

    it 'calculates a balance until a date' do
      expect(@account.balance(date_from('02-01-2015'))).to eq 90
    end

    context "given an account has 'Assets' type" do

      assert_positive_debits_negative_credits

    end

    context "given an account has 'Liabilities' type" do

      before do
        @account.name = 'Account Payable'
        @account.category = 'Liabilities'
      end

      assert_positive_credits_negative_debits

    end

    context "given an account has 'Equity' type" do

      before do
        @account.name = 'Capital'
        @account.category = 'Equity'
      end

      assert_positive_credits_negative_debits

    end

    context "given an account has 'Revenue' type" do

      before do
        @account.name = 'Salary'
        @account.category = 'Revenue'
      end

      assert_positive_credits_negative_debits

    end

    context "given an account has 'Expenses' type" do

      before do
        @account.name = 'Food'
        @account.category = 'Expenses'
      end

      assert_positive_debits_negative_credits

    end

  end

end
