require 'validators/revenue_validator'
require 'validators/asset_validator'
require 'services/accounting_transaction_maker'

class RevenueTransactionMaker < AccountingTransactionMaker

  validates :from, revenue: true
  validates :to, asset: true

  def exception_message
    'The revenue transaction is not valid'
  end

end
