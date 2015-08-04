require 'spec_helper'
require 'use_cases/make_revenue_transaction'

include MakeTransactionAssertable

describe 'Making a Revenue Transaction' do

  it "when a salary payment of value 1000 occurs then it creates an entry of 1000 for 'Salary' and entry of 1000 for 'Savings Account'" do
    salary = Account.new(name: 'Salary', category: 'Revenue')
    savings_account = Account.new(name: 'Savings account', category: 'Assets')
    salary_payment = create_transaction_type({
                                                 type: MakeRevenueTransaction,
                                                 book_date: Date.today,
                                                 from_account: salary,
                                                 to_account: savings_account,
                                                 amount: 1000
                                             })

    salary_payment.save

    assert_transaction({
                       transaction: salary_payment.transaction,
                       book_date: Date.today,
                       from_account: salary, from_amount: 1000,
                       to_account: savings_account, to_amount: 1000
                   })
  end

  
  basic_validation('Given a new revenue transaction, when checking for validation', MakeRevenueTransaction)

  context "Given an a revenue transaction with a to account category not 'Assets'" do

    before do
      @salary = Account.new(name: 'Salary', category: 'Revenue')
      @accounts_payable = Account.new(name: 'Accounts Payable', category: 'Liabilities')
      @salary_payment = create_transaction_type({
                                                    type: MakeRevenueTransaction,
                                                    from_account: @salary,
                                                    to_account: @accounts_payable,
                                                    amount: 1000
                                                })
    end

    it 'when checking validation an error occurs for to account' do
      expect(@salary_payment.valid?).to be_false
      expect(@salary_payment.errors[:to].any?).to be_true
      expect(@salary_payment.errors[:to]).to eq ['The to account category is not Assets']
    end

    it 'when saving the transaction then it raises an exception' do
      expect { @salary_payment.save }.to raise_error(RuntimeError, 'The revenue transaction is not valid')
    end

  end

  it "when revenue transaction with a from account category not 'Revenue' is checked for validation, then there are validation errors for the from account" do
    accounts_payable = Account.new(name: 'Accounts Payable', category: 'Liabilities')
    savings_account = Account.new(name: 'Savings account', category: 'Assets')
    salary_payment = create_transaction_type({
                                                 type: MakeRevenueTransaction,
                                                 from_account: accounts_payable,
                                                 to_account: savings_account,
                                                 amount: 1000
                                             })

    expect(salary_payment.valid?).to be_false

    expect(salary_payment.errors[:from].any?).to be_true
    expect(salary_payment.errors[:from]).to eq ['The from account category is not Revenue']
  end

end
