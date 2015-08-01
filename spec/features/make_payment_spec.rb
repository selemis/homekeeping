require 'spec_helper'
require 'pay_expense'

include MakePaymemntAssertable


describe 'Making an expense payment' do

  context 'Paying Groceries with Cash' do

    it 'creates a transaction that transfers money from cash account to groceries account' do
      cash = Account.new(name: 'Cash', category: 'Assets')
      groceries = Account.new(name: 'Groceries', category: 'Expenses')
      pay = PayExpense.new do |p|
        p.from = cash
        p.to = groceries
        p.date = Date.today
        p.amount = 100
      end

      pay.save

      assert_payment({
                         transaction: pay.transaction,
                         first_account: cash, first_amount: -100,
                         second_account: groceries, second_amount: 100
                     })
    end

  end

  context 'Paying Rent by transferring Money from Bank Account' do

    it 'creates a transaction that transfers money from bank account to house rent' do
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

    it 'creates a transaction that credits the liabilities and debits the expenses' do
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

  context 'An expense payment is valid' do

    context 'Given a new expense payment' do

      before do
        @pay = PayExpense.new
        @pay.valid?
      end

      it 'requires a book date' do
        expect(@pay.errors[:date].any?).to be_true
      end

      it 'requires a from account' do
        expect(@pay.errors[:from].any?).to be_true
      end

      it 'requires a to account' do
        expect(@pay.errors[:to].any?).to be_true
      end

      it 'requires an amount' do
        expect(@pay.errors[:amount].any?).to be_true
      end

    end

    it 'when a from account must be an Asset or a Liabilities type' do

      equity = Account.new(name: 'Equity', category: 'Equity')
      rent = Account.new(name: 'Rent', category: 'Expenses')

      pay = PayExpense.new do |p|
        p.from = equity
        p.to = rent
        p.date = Date.today
        p.amount = 550
      end

      expect(pay.valid?).to be_false
      expect(pay.errors[:from].any?).to be_true
      expect(pay.errors[:from]).to eq ['The from account category is not Liabilities or Assets']
    end

    it 'when a from account must be an Expense type'

  end


  it 'does not save the payment if it is not valid'

end
