require 'spec_helper'
require 'use_cases/asset_to_liabilities_transaction_maker'

include TransactionMakerAsserter

describe 'Making an asset to liabilities transaction' do

  from_account_invalid_category({
                                    message: "when having an asset to liablities transaction with a from account of category not 'Assets' then it is invalid",
                                    transaction_maker: AssetToLiabilitiesTransactionMaker,
                                    from_account_category: 'Equity',
                                    to_account_category: 'Liabilities',
                                    error_message: 'The from account category is not Assets'
                                })

  to_account_invalid_category({
                                  message: "when having an asset to liablities transaction with a to account of category not 'Liabilities'",
                                  transaction_maker: AssetToLiabilitiesTransactionMaker,
                                  from_account_category: 'Assets',
                                  to_account_category: 'Assets',
                                  error_message: 'The to account category is not Liabilities'
                              })


  it 'then it should not save the payment because it is not valid' do
    transaction_maker = create_transaction_maker({
                                       transaction_maker: AssetToLiabilitiesTransactionMaker,
                                       from_account_category: 'Assets',
                                       to_account_category: 'Assets',
                                   })

    expect { transaction_maker.save }.to raise_error(RuntimeError, 'The asset to liabilities transaction is not valid')
  end

end