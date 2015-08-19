class DebitAccount

  attr_accessor :account, :amount, :book_date

  def debit
    entry = AccountingEntryBo.new
    entry.account = account
    entry.book_date = book_date
    entry.amount = amount * amount_sign_for_debit
    entry
  end

  def amount_sign_for_debit
    category_object.amount_sign_for_debit
  end

  def category_object
    Object.const_get(account.category).new
  end


end