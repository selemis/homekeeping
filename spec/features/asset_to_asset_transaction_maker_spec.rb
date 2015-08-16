require 'spec_helper'
require 'use_cases/asset_to_asset_transaction_maker'
require_relative '../support/transaction_maker_asserter'

include TransactionMakerAsserter

describe "Making an 'Assets' to 'Assets' transaction " do

  it 'when I deposit 100 value of cash to savings account, then it creates an entry of -100 for cash and an entry of 100 for savings account' do
    cash = Account.new(name: 'Cash', category: 'Assets')
    savings_account = Account.new(name: 'Savings Account', category: 'Assets')

    deposit = create_transaction_type({
                                          type: AssetToAssetTransactionMaker,
                                          book_date: Date.today,
                                          from_account: cash,
                                          to_account: savings_account,
                                          amount: 1000
                                      })

    deposit.save

    assert_transaction({
                           transaction: deposit.transaction,
                           book_date: Date.today,
                           from_account: cash, from_amount: -1000,
                           to_account: savings_account, to_amount: 1000
                       })

  end

  basic_validation("Given a new 'Assets' to 'Assets' transaction, when checking for validation", AssetToAssetTransactionMaker)

  context "given an 'Assets' to 'Assets' transaction with a from category not 'Assets' " do

    from_account_invalid_category({
                                      message: 'when checking for validation then an error occurs for the from account',
                                      transaction_maker: AssetToAssetTransactionMaker,
                                      from_account_category: 'Liabilities',
                                      to_account_category: 'Assets',
                                      error_message: 'The from account category is not Assets'
                                  })

    it 'when saving the transaction then it raises an exception' do
      deposit = create_transaction_maker ({
                                        transaction_maker: AssetToAssetTransactionMaker,
                                        from_account_category: 'Liabilities',
                                        to_account_category: 'Assets',
                                    })

      expect { deposit.save }.to raise_error(RuntimeError, 'The asset transaction is not valid')
    end

  end

  to_account_invalid_category({
                                  message: "given 'Assets' to 'Assets' transaction with a to account category not 'Assets' when checking for validation then an errors occurs for the to account",
                                  transaction_maker: AssetToAssetTransactionMaker,
                                  from_account_category: 'Assets',
                                  to_account_category: 'Liabilities',
                                  error_message: 'The to account category is not Assets'
                              })

end
