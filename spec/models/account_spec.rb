require 'spec_helper'
require 'services/credit_calculator'
require 'services/debit_calculator'

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

end
