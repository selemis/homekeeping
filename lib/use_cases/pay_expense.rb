require'validators/asset_or_liabilities_validator'
require 'validators/expenses_validator'
require 'use_cases/accounting_transaction_maker'

class PayExpense < AccountingTransactionMaker

  validates :from, asset_or_liabilities: true
  validates :to, expenses: true

  def exception_message
    'The expense payment is not valid'
  end

end
