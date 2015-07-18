require 'accounting_transaction'
require 'spec_helper'

include TransactionAssertable

describe 'placing an accounting transaction' do
  
  before do
    Account.delete_all
  end

  context 'salary payment with cash' do

    before do
      @salary = Account.new(name: 'Salary', category: 'Revenue')
      @cash = Account.new(name: 'Cash', category: 'Assets')

      @transaction = AccountingTransaction.new
      @transaction.credit(@salary, 100)
      @transaction.debit(@cash, 100)
    end  

    it 'credits the salary account with an amount and debits the cash account with the same amount' do
      #TODO remember booking date
      @transaction.place

      assert_transaction_placement({
           credit_account: @salary, 
           debit_account: @cash, 
           credit: 100, 
           debit: 100
      })
      expect(@transaction.valid?).to be_true
    end

    it 'commiting the transaction saves the accounting entries to the database' do
      @transaction.place
      @transaction.commit

      assert_account_from_db @cash
      assert_account_from_db @salary
    end

  end

  context 'Withdraw money from bank' do

    before do
      @cash = Account.new(name: 'Cash', category: 'Assets')
      @savings_account = Account.new(name: 'Savings Account', category: 'Assets')

      @transaction = AccountingTransaction.new
      @transaction.credit(@savings_account, 100)
      @transaction.debit(@cash, 100)
    end
    
    it 'debits the salary account with an amount and credits the savings account with the same amount' do
      @transaction.place

      assert_transaction_placement({
           credit_account: @savings_account, 
           debit_account: @cash, 
           credit: -100, 
           debit: 100
      })
      expect(@transaction.valid?).to be_true
    end

    it 'commiting the transaction saves the accounting entries to the database' do
      @transaction.place
      @transaction.commit

      assert_account_from_db @cash
      assert_account_from_db @savings_account
    end
  
  end

  context 'Pay for food with cash' do

    before do
      @cash = Account.new(name: 'Cash', category: 'Assets')
      @groceries = Account.new(name: 'Groceries', category: 'Expenses')

      @transaction = AccountingTransaction.new
      @transaction.credit(@cash, 50)
      @transaction.debit(@groceries, 50)
    end


    it 'credits the cash account and debits the groceries account with the same amount' do
      @transaction.place

      assert_transaction_placement({
           credit_account: @cash, 
           debit_account: @groceries, 
           credit: -50, 
           debit: 50
      })
    end

    it 'commiting the transaction saves the accounting entries to the database' do
      @transaction.place
      @transaction.commit

      assert_account_from_db @cash
      assert_account_from_db @groceries
    end

  end

  after do
    Account.delete_all
  end

end

