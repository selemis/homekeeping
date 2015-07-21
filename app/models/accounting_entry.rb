class AccountingEntry < ActiveRecord::Base

  validates :book_date, :amount, presence: true
  belongs_to :account
  belongs_to :accounting_transaction

  def credit?
    (%w[Assets Expenses].include?(account.category) and amount < 0) or 
    (%w[Liabilities Equity Revenue].include?(account.category) and amount > 0)
  end

  def debit?
    (%w[Assets Expenses].include?(account.category) and amount > 0) or
    (%w[Liabilities Equity Revenue].include?(account.category) and amount < 0)
  end

end
