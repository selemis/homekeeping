class Account < ActiveRecord::Base

  TYPES = %w[Assets Liabilities Equity Revenue Expenses]

  alias_attribute :category, :type
  has_many :accounting_entries
  validates :name, presence: true
  validates :type, inclusion: {in: TYPES}

  def balance(until_date=nil)
    return 0 if accounting_entries.empty?
    filter = date_filter(until_date)
    accounting_entries
        .select { |entry| filter.call(entry) }
        .map { |entry| entry.amount }
        .reduce(:+)
  end

  def debit(until_date=nil)
    return 0 if accounting_entries.empty?
    filter = date_filter(until_date)
    case category
      when 'Assets', 'Expenses'
        accounting_entries
            .select { |entry| filter.call(entry) }
            .select { |entry| entry.amount > 0 }
            .map { |entry| entry.amount }
            .reduce(:+)
      when 'Liabilities', 'Equity', 'Revenue'
        accounting_entries
            .select { |entry| filter.call(entry) }
            .reject { |entry| entry.amount > 0 }
            .map { |entry| entry.amount }
            .reduce(:+)
      else
        0
    end
  end

  def credit(until_date=nil)
    return 0 if accounting_entries.empty?
    filter = date_filter(until_date)
    case category
      when 'Assets', 'Expenses'
        accounting_entries
            .select { |entry| filter.call(entry) }
            .reject { |entry| entry.amount > 0 }
            .map { |entry| entry.amount }
            .reduce(:+)
      when 'Liabilities', 'Equity', 'Revenue'
        accounting_entries
            .select { |entry| filter.call(entry) }
            .select { |entry| entry.amount > 0 }
            .map { |entry| entry.amount }
            .reduce(:+)
      else
        0
    end
  end

  private

  def date_filter(until_date)
    if until_date.nil?
      Proc.new { true }
    else
      Proc.new { |entry| entry.book_date <= until_date }
    end
  end

end
