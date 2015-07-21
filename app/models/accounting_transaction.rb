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
      entry = account.credit(amount)
      accounting_entries << entry
    end
  
    @debits.each do |account, amount|
      entry = account.debit(amount)
      accounting_entries << entry
    end

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
    else
      raise errors.full_messages.join(',')
    end
  end

  private

  def credits_equals_debits?
    d = accounting_entries.select{|entry| entry.debit?}.map{|entry| entry.amount.abs}.reduce(:+)
    c = accounting_entries.select{|entry| entry.credit?}.map{|entry| entry.amount.abs}.reduce(:+)
    d == c
    #@credits.map { |account, amount| amount.abs }.reduce(:+) == @debits.map { |account, amount| amount.abs }.reduce(:+)
  end

  def double_check_credits_debits
    errors.add(:credits_debits, "Credits not equal debits") unless credits_equals_debits?
  end

  def at_least_2_entries
    errors.add(:accounting_entries_size, "Account must have at least 2 entries") if accounting_entries.size < 2
  end
  
end
