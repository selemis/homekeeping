class AccountingTransaction < ActiveRecord::Base

  has_many :accounting_entries
  validate :double_check_credits_debits, :at_least_2_entries
  validates :book_date, presence: true

  def initialize
    super
    @credits = Hash.new
    @debits = Hash.new
  end
   
  def credit(account, amount)
    @credits[account] = amount
  end

  def debit(account, amount)
    @debits[account] = amount
  end

  def place

    #TODO change date
    #TODO remember to save
    @credits.each do |account, amount|
      amount_with_sign = amount_sign_for_credit(account) * amount
      entry = AccountingEntry.new(book_date: Date.today, amount: amount_with_sign)
      accounting_entries << entry
      account.accounting_entries << entry
    end
  
    @debits.each do |account, amount|
      amount_with_sign = amount_sign_for_debit(account) * amount
      entry = AccountingEntry.new(book_date: Date.today, amount: amount_with_sign)
      accounting_entries << entry
      account.accounting_entries << entry
    end

  end

  def credits_equals_debits?
    @credits.map { |account, amount| amount.abs }.reduce(:+) == @debits.map { |account, amount| amount.abs }.reduce(:+)
  end

  def double_check_credits_debits
    errors.add(:credit_debits, "Credits not equal debits") unless credits_equals_debits?
  end

  def at_least_2_entries
    errors.add(:accounting_entries_size, "Account must have at least 2 entries") if accounting_entries.size < 2
  end

  def save
    if valid?
      ActiveRecord::Base.transaction do
        super
        #TODO this code should not be necessary because it saves to account through
        #the accounting entries. Remember to delete and check
        @credits.each { |account, amount| account.save }
        @debits.each { |account, amount| account.save }
      end
    end
  end
  
  private

  #duplicated fix later
  def amount_sign_for_debit(account)
    case account.category
      when 'Assets', 'Expenses'
        1
      when 'Liabilities', 'Equity', 'Revenue'
        -1
      else
        1
    end
  end

  #duplicated fix later
  def amount_sign_for_credit(account)
    -1 * amount_sign_for_debit(account)
  end
  
end
