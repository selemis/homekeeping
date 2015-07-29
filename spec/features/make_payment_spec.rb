require 'spec_helper'
require 'pay_expense'


def assert_payment(values)
    trans = values[:transaction]
    expect(trans.valid?).to be_true
    expect(trans.accounting_entries.size).to eq 2
    entry1 = trans.accounting_entries.select {|entry| entry.account == values[:first_account]}.first
    entry2 = trans.accounting_entries.select {|entry| entry.account == values[:second_account]}.first
    expect(entry1.amount).to eq values[:first_amount]
    expect(entry2.amount).to eq values[:second_amount]
end



describe 'Making an expense payment' do

  context 'Paying Groceries with Cash' do

    before do
      @cash = Account.new(name: 'Cash', category: 'Assets')
      @groceries = Account.new(name: 'Groceries', category: 'Expenses')
    end

    it 'creates a transaction that transfers money from cash account to groceries account' do

      pay = PayExpense.new do |p|
        p.from = @cash
        p.to = @groceries
        p.date = Date.today
        p.amount = 100
      end
      pay.save

      assert_payment({
          transaction: pay.transaction, 
          first_account: @cash, first_amount: -100, 
          second_account: @groceries, second_amount: 100
      })
    end

  end

  context 'Pay Rent by Trasfering Money from Bank Account' do

    it 'creates a transaction that tranfers money from bank account to house rent' do
      bank_account = Account.new(name: 'Bank', category: 'Assets')
      rent = Account.new(name: 'Rent', category: 'Expenses')

      pay = PayExpense.new do |p|
        p.from = bank_account
        p.to = rent
        p.date = Date.today
        p.amount = 550
      end
      pay.save

      assert_payment({
          transaction: pay.transaction, 
          first_account: bank_account, first_amount: -550, 
          second_account: rent, second_amount: 550
      })
    end

  end

  context 'Pay mobile bill with credit card' do

    it 'creates a transaction that credits the liabilites and debits the expenses' do
      accounts_payable = Account.new(name: 'Credit card', category: 'Liabilities')
      mobile = Account.new(name: 'Wind', category: 'Expenses')
      
      pay = PayExpense.new do |p|
        p.from = accounts_payable
        p.to = mobile
        p.date = Date.today
        p.amount = 40
      end
      pay.save

      assert_payment({
          transaction: pay.transaction, 
          first_account: accounts_payable, first_amount: 40, 
          second_account: mobile, second_amount: 40
      })
    end

  end

end
