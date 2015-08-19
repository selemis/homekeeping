class AccountingTransaction < ActiveRecord::Base

  has_many :accounting_entries
  validate :double_check_credits_debits, :at_least_2_entries, :same_entries_book_dates
  validates :book_date, presence: true

  def credit(account, amount)
    action(CreditAccount.new, account, amount)
  end

  def debit(account, amount)
    action(DebitAccount.new, account, amount)
  end

  private

  def action(operation, account, amount)
    operation.account = account
    operation.book_date = book_date
    operation.amount = amount
    entry = operation.create_entry
    accounting_entry = AccountingEntry.new(book_date: entry.book_date, amount: entry.amount)
    account.accounting_entries << accounting_entry
    accounting_entries << accounting_entry
  end

  def credits_equals_debits?
    sum_entry_amounts {|entry| entry.debit?} == sum_entry_amounts {|entry| entry.credit?} 
  end

  def sum_entry_amounts
    accounting_entries.select{|entry| yield(entry) }.map{|entry| entry.amount.abs}.reduce(:+)
  end

  def double_check_credits_debits
    errors.add(:credits_debits, 'Credits not equal debits') unless credits_equals_debits?
  end

  def at_least_2_entries
    errors.add(:accounting_entries_size, 'Account must have at least 2 entries') if accounting_entries.size < 2
  end

  def same_entries_book_dates
    if accounting_entries.reject {|entry| entry.book_date == book_date}.size > 0
      errors.add(:entries_book_date, 'Accounting entries and transaction do not have the same book dates')
    end
  end
  
end
