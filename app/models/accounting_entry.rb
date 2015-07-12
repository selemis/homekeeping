class AccountingEntry < ActiveRecord::Base

  validates :book_date, :amount, presence: true
  belongs_to :account
end
