require 'use_cases/accounting_transaction_maker'
require 'validators/asset_validator'

class AssetToAssetTransactionMaker < AccountingTransactionMaker

  validates :from, asset: true
  validates :to, asset: true

  def exception_message
    'The asset transaction is not valid'
  end


end
