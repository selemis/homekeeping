class AccountingEntry < ActiveRecord::Base

  validates :book_date, :amount, presence: true
end
