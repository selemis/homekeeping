class AccountingEntry < ActiveRecord::Base

  validates :book_date, :amount, presence: true
  belongs_to :account
  belongs_to :accounting_transaction

  def credit?
    (category_object.negative_amount_credit and amount < 0) or
    (category_object.positive_amount_credit and amount > 0)
  end

  def debit?
    (category_object.positive_amount_debit and amount > 0) or
    (category_object.negative_amount_debit and amount < 0)
  end

  private 

  #duplicated
  def category_object
    Object.const_get(account.category).new
  end

end
