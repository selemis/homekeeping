require 'spec_helper'
require 'use_cases/revenue_transaction_maker'

include TransactionMakerAsserter

describe 'Making a Revenue Transaction' do

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
