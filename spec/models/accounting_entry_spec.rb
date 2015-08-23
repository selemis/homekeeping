require 'spec_helper'

def entry_with_amount_and_account_with_category(amount, category)
  account = Account.new(account_attributes(category: category))
  entry = AccountingEntry.new(accounting_entry_attributes(amount: amount))
  entry.account = account
  entry
end

describe AccountingEntry do

  context 'given an new accounting entry' do

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

    it 'can belong to an account' do
      account = Account.new(account_attributes)
      account.accounting_entries << @accounting_entry

      expect(@accounting_entry.account).to eq account
    end

  end

  context 'given a new accounting entry, when checking for validation' do

    before do
      @accounting_entry = AccountingEntry.new

      @accounting_entry.valid?
    end

    it 'it requires a booking date' do
      expect(@accounting_entry.errors[:book_date].any?).to eq(true)
    end

    it 'is requires an amount' do
      expect(@accounting_entry.errors[:amount].any?).to eq(true)
    end

  end

  it "given an entry with negative amount and account category 'Assets' then it is a credit entry" do
    entry = entry_with_amount_and_account_with_category -100, 'Assets'

    expect(entry.credit?).to be(true)
    expect(entry.debit?).to be(false)
  end

  it "given an entry with positive amount and account category 'Assets' then it is a debit entry" do
    entry = entry_with_amount_and_account_with_category 100, 'Assets'

    expect(entry.credit?).to be(false)
    expect(entry.debit?).to be(true)
  end

  it "given an entry with negative amount and account category 'Expenses' then it is a credit entry" do
    entry = entry_with_amount_and_account_with_category -100, 'Expenses'

    expect(entry.credit?).to be(true)
    expect(entry.debit?).to be(false)
  end

  it "given an entry with positive amount and account category 'Expenses' then it is a debit entry" do
    entry = entry_with_amount_and_account_with_category 100, 'Expenses'

    expect(entry.credit?).to be(false)
    expect(entry.debit?).to be(true)
  end

  it "given an entry with positive amount and account category 'Liabilities' then it is a credit entry" do
    entry = entry_with_amount_and_account_with_category 100, 'Liabilities'

    expect(entry.credit?).to be(true)
    expect(entry.debit?).to be(false)
  end

  it "given an entry with negative amount and account category 'Liabilities' then it is a debit entry" do
    entry = entry_with_amount_and_account_with_category -100, 'Liabilities'

    expect(entry.credit?).to be(false)
    expect(entry.debit?).to be(true)
  end

  it "given an entry with positive amount and account category 'Equity' then it is a credit entry" do
    entry = entry_with_amount_and_account_with_category 100, 'Equity'

    expect(entry.credit?).to be(true)
    expect(entry.debit?).to be(false)
  end

  it "given an entry with negative amount and account category 'Equity' then it is a debit entry" do
    entry = entry_with_amount_and_account_with_category -100, 'Equity'

    expect(entry.credit?).to be(false)
    expect(entry.debit?).to be(true)
  end

  it "given an entry with positive amount and account category 'Revenue' then it is a credit entry" do
    entry = entry_with_amount_and_account_with_category 100, 'Revenue'

    expect(entry.credit?).to be(true)
    expect(entry.debit?).to be(false)
  end

  it "given an entry with negative amount and account category 'Revenue' then it is a debit entry" do
    entry = entry_with_amount_and_account_with_category -100, 'Revenue'

    expect(entry.credit?).to be(false)
    expect(entry.debit?).to be(true)
  end

end
