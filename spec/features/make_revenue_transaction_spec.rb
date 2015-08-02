require 'spec_helper'
require 'use_cases/make_revenue_transaction'

#TODO rename
include MakePaymemntAssertable

describe 'Given making a Revenue Transaction' do

  context 'when salary payment occurs' do

    it 'debits an asset account and credit a revenue account' do

      salary = Account.new(name: 'Salary', category: 'Revenue')
      savings_account = Account.new(name: 'Savings account', category: 'Assets')

      salary_payment = MakeRevenueTransaction.new do |mrt|
        mrt.from = salary
        mrt.to = savings_account
        mrt.date = Date.today
        mrt.amount = 1000
      end

      salary_payment.save

      assert_payment({
                         transaction: salary_payment.transaction,
                         first_account: salary, first_amount: 1000,
                         second_account: savings_account, second_amount: 1000
                     })

    end

  end

  context 'Given a revenue transaction, it is valid' do

    before do
      @pay = MakeRevenueTransaction.new
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

  context 'Given an invalid type of account' do

    before do
      @salary = Account.new(name: 'Salary', category: 'Revenue')
      @accounts_payable = Account.new(name: 'Accounts Payable', category: 'Liabilities')

      @salary_payment = MakeRevenueTransaction.new do |mrt|
        mrt.from = @salary
        mrt.to = @accounts_payable
        mrt.date = Date.today
        mrt.amount = 1000
      end

    end

    it 'when a to account must be an Assets type' do
      expect(@salary_payment.valid?).to be_false
      expect(@salary_payment.errors[:to].any?).to be_true
      expect(@salary_payment.errors[:to]).to eq ['The to account category is not Assets']
    end

    it 'does not save the payment if it is not valid' do
      expect { @salary_payment.save }.to raise_error(RuntimeError, 'The revenue transaction is not valid')
    end

  end

  it  'when a from account must be a Revenue type' do
    accounts_payable = Account.new(name: 'Accounts Payable', category: 'Liabilities')
    savings_account = Account.new(name: 'Savings account', category: 'Assets')

    salary_payment = MakeRevenueTransaction.new do |mrt|
      mrt.from = accounts_payable
      mrt.to = savings_account
      mrt.date = Date.today
      mrt.amount = 1000
    end

    expect(salary_payment.valid?).to be_false
    expect(salary_payment.errors[:from].any?).to be_true
    expect(salary_payment.errors[:from]).to eq ['The from account category is not Revenue']

  end

end