require 'spec_helper'
require 'use_cases/pay_expense'
require 'use_cases/revenue_transaction_maker'
require_relative '../support/transaction_maker_asserter'

include TransactionMakerAsserter

describe 'Displaying a transaction grid' do

  #I am not ready for this test yet
  #I need an Assets to Assets transaction (deposit, withdraw, transfer)
  #I need an Assets to Liability transaction (Get a loan)
  pending 'Other stuff should be done first' do


    it 'Given various transactions, when asking for the transaction grid then it displays the grid' do

      cash = Account.create(name: 'Cash', category: 'Assets')
      checking_account= Account.create(name: 'Checking Account', category: 'Assets')
      savings_account= Account.create(name: 'Savings Account', category: 'Assets')
      credit_card = Account.create(name: 'Credit Card', category: 'Liabilities')
      loan = Account.create(name: 'Loan', category: 'Liabilities')
      groceries = Account.create(name: 'Groceries', category: 'Expenses')
      mobile = Account.create(name: 'Mobile', category: 'Expenses')
      rent = Account.create(name: 'Rent', category: 'Expenses')
      salary = Account.create(name: 'Salary', category: 'Revenue')


      pay = create_transaction_type({
                                        type: MakeRevenueTransaction,
                                        from_account: salary,
                                        to_account: cash,
                                        amount: 1000})
      pay.date = Date.parse('2015-01-01')
      pay.save

      pay = create_transaction_type({
                                        type: PayExpense,
                                        from_account: cash,
                                        to_account: groceries,
                                        amount: 10})
      pay.date = Date.parse('2015-01-10')
      pay.save

      pay = create_transaction_type({
                                        type: PayExpense,
                                        from_account: cash,
                                        to_account: groceries,
                                        amount: 10})
      pay.date = Date.parse('2015-01-10')
      pay.save

      p AccountingTransaction.all
      p AccountingEntry.all


    end

  end

  #Sample code for later
  # account1 = 'Cash'
  # account2 = 'Savings Account'
  # account3 = 'Loan'
  # account4 = 'Accounts Payable'
  # account5 = 'Mobile'
  # account6 = 'Groceries'
  #
  # header = [account1, account2, account3, account4, account5, account6]
  #
  # @grid = []
  # @grid << header
  #
  #
  # def print
  #   @grid.each do |row|
  #     puts row.join(" | ")
  #   end
  # end
  #
  # def index
  #
  # end
  #
  #
  # def add(from, to, amount_from, amount_to)
  #   new_row = []
  #   puts @grid[0].size
  #   (@grid[0].size).times do |i|
  #     new_row << '*'
  #   end
  #
  #   from_index = @grid[0].index(from)
  #   to_index = @grid[0].index(to)
  #
  #   new_row[from_index] = amount_from
  #   new_row[to_index] = amount_to
  #
  #   @grid << new_row
  #
  # end
  #
  #
  # add(account1, account6, -100, 100)
  # add(account2, account5, -200, 200)
  #
  # print


end
