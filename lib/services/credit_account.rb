require 'business_objects/accounting_entry_bo'

class CreditAccount

  attr_accessor :account, :amount, :book_date

  def credit
    entry = AccountingEntryBo.new
    entry.account = account
    entry.book_date = book_date
    entry.amount = amount * amount_sign_for_credit
    entry
  end

  def amount_sign_for_credit
    category_object.amount_sign_for_debit * (-1)
  end

  def category_object
    Object.const_get(account.category).new
  end

end