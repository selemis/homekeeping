require 'spec_helper'
require 'pay_expense'

describe 'Making an expense payment' do

  context 'Paying Groceries with Cash' do

    before do
      @cash = Account.new(name: 'Cash', category: 'Assets')
      @groceries = Account.new(name: 'Groceries', category: 'Expenses')
    end

    it 'creates a transaction that transfers money from cash account to groceries account' do
      pay = PayExpense.new
      pay.from = @cash
      pay.to = @groceries
      pay.date = Date.today
      pay.amount = 100
      pay.save

      transaction = pay.transaction
      expect(transaction.valid?).to be_true
      expect(transaction.accounting_entries.size).to eq 2
      expect(@cash.calculate_credit).to eq -100
      expect(@groceries.calculate_debit).to eq 100
    end

  end

  context 'Pay Rent by Trasfering Money from Bank Account' do

    it 'creates a transaction that tranfers money from bank account to house rent' do
      bank_account = Account.new(name: 'Bank', category: 'Assets')
      rent = Account.new(name: 'Rent', category: 'Expenses')
    end

  end

end
