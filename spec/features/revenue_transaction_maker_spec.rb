require 'spec_helper'
require 'use_cases/revenue_transaction_maker'

include TransactionMakerAsserter

describe 'Making a Revenue Transaction' do

  it "when a salary payment of value 1000 occurs then it creates an entry of 1000 for 'Salary' and entry of 1000 for 'Savings Account'" do
    salary = Account.new(name: 'Salary', category: 'Revenue')
    savings_account = Account.new(name: 'Savings account', category: 'Assets')
    salary_payment = create_transaction_type({
                                                 type: RevenueTransactionMaker,
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

  
  basic_validation('Given a new revenue transaction, when checking for validation', RevenueTransactionMaker)

  context "Given an a revenue transaction with a to account category not 'Assets'" do

    from_account_invalid_category({
                                      message: "when revenue transaction with a from account category not 'Revenue' is checked for validation, then there are validation errors for the from account",
                                      transaction_maker: RevenueTransactionMaker,
                                      from_account_category: 'Liabilities',
                                      to_account_category: 'Assets',
                                      error_message: 'The from account category is not Revenue'
                                  })

    to_account_invalid_category({
                                    message: 'when checking validation an error occurs for to account',
                                    transaction_maker: RevenueTransactionMaker,
                                    from_account_category: 'Revenue',
                                    to_account_category: 'Liabilities',
                                    error_message: 'The to account category is not Assets'
                                })
    
    it 'when saving the transaction then it raises an exception' do
      salary_payment = create_transaction_maker({
                                                    transaction_maker: RevenueTransactionMaker,
                                                    from_account_category: 'Revenue',
                                                    to_account_category: 'Liabilities',
                                                })

      expect { salary_payment.save }.to raise_error(RuntimeError, 'The revenue transaction is not valid')
    end

  end


end
