require 'use_cases/make_accounting_transaction'
require 'validators/asset_validator'

class AssetToAssetTransaction < MakeAccountingTransaction

  validates :from, asset: true
  validates :to, asset: true

  def exception_message
    'The asset transaction is not valid'
  end


end