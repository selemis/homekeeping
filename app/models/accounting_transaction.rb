class AccountingTransaction < ActiveRecord::Base

  has_many :accounting_entries
  validate :double_check_credits_debits, :at_least_2_entries
  validates :book_date, presence: true

  def credit(account, amount)
    accounting_entries << account.credit(amount)
  end

  def debit(account, amount)
    accounting_entries << account.debit(amount)
  end

  private

  def credits_equals_debits?
    accounting_entries.select{|entry| entry.debit?}.map{|entry| entry.amount.abs}.reduce(:+) ==
    accounting_entries.select{|entry| entry.credit?}.map{|entry| entry.amount.abs}.reduce(:+)
  end

  def double_check_credits_debits
    errors.add(:credits_debits, "Credits not equal debits") unless credits_equals_debits?
  end

  def at_least_2_entries
    errors.add(:accounting_entries_size, "Account must have at least 2 entries") if accounting_entries.size < 2
  end
  
end
