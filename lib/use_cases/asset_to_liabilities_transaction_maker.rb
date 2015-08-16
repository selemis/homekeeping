require 'validators/asset_validator'
require 'validators/liabilities_validator'

class AssetToLiabilitiesTransactionMaker < AccountingTransactionMaker

  validates :from, asset: true
  validates :to, liabilities: true

  def exception_message
    'The asset to liabilities transaction is not valid'
  end

end
