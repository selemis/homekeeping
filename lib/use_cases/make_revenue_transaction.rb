require 'validators/revenue_validator'
require 'validators/asset_validator'
require 'use_cases/make_accounting_transaction'

class MakeRevenueTransaction < MakeAccountingTransaction

  validates :from, revenue: true
  validates :to, asset: true

  def exception_message
    'The revenue transaction is not valid'
  end

end
