class Account < ActiveRecord::Base

  TYPES = %w[Assets Liabilities Equity Revenue Expenses]

  alias_attribute :category, :type
  has_many :accounting_entries
  validates :name, presence: true
  validates :type, inclusion: {in: TYPES}

  def balance(until_date=nil)
    return 0 if accounting_entries.empty?
    sum_amounts(filtered_entries(date_filter(until_date)))
  end

  def debit(until_date=nil)
    return 0 if accounting_entries.empty?
    filter = date_filter(until_date)
    case category
      when 'Assets', 'Expenses'
        sum_amounts(positive_entries(filtered_entries(filter)))
      when 'Liabilities', 'Equity', 'Revenue'
        sum_amounts(negative_entries(filtered_entries(filter)))
      else
        0
    end
  end

  def credit(until_date=nil)
    return 0 if accounting_entries.empty?
    filter = date_filter(until_date)
    case category
      when 'Assets', 'Expenses'
        sum_amounts(negative_entries(filtered_entries(filter)))
      when 'Liabilities', 'Equity', 'Revenue'
        sum_amounts(positive_entries(filtered_entries(filter)))
      else
        0
    end
  end

  private

  def sum_amounts(entries)
    entries.map { |entry| entry.amount }.reduce(:+)
  end

  def positive_entries(entries)
    entries.select { |entry| entry.amount > 0 }
  end

  def negative_entries(entries)
    entries.reject { |entry| entry.amount > 0 }
  end

  def filtered_entries(filter)
    accounting_entries.select { |entry| filter.call(entry) }
  end

  def date_filter(until_date)
    if until_date.nil?
      Proc.new { true }
    else
      Proc.new { |entry| entry.book_date <= until_date }
    end
  end

end
