require 'business_objects/accounting_entry_bo'
require 'liabilities'

class PerformOnAccount

  attr_accessor :account, :amount, :book_date

  def create_entry
    entry = AccountingEntryBo.new
    entry.account = account
    entry.book_date = book_date
    entry.amount = amount * amount_sign
    entry
  end

  private

  def category_object
    Object.const_get(account.category).new
  end

end
