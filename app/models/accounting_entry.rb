class AccountingEntry < ActiveRecord::Base

  validates :book_date, :amount, presence: true
  belongs_to :account
  belongs_to :accounting_transaction

end
