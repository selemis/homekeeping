class Account < ActiveRecord::Base

  CATEGORIES = [Assets.name, Liabilities.name, Equity.name, Revenue.name, Expenses.name]

  has_many :accounting_entries
  validates :name, presence: true
  validates :category, inclusion: {in: CATEGORIES}

  def balance(until_date=nil)
    return 0 if accounting_entries.empty?
    sum_amounts_of(filtered_entries(date_filter(until_date)))
  end

  def calculate_debit(until_date=nil)
    process(until_date, sum_positive_filtered_entries, sum_negative_filtered_entries)
  end

  def calculate_credit(until_date=nil)
    process(until_date, sum_negative_filtered_entries, sum_positive_filtered_entries)
  end

  #TODO change date
  #TODO remember to save
  def credit(amount)
    entry = AccountingEntry.new(book_date: Date.today, amount: amount_sign_for_credit * amount)
    accounting_entries << entry
    entry
  end

  def debit(amount)
    entry = AccountingEntry.new(book_date: Date.today, amount: amount_sign_for_debit * amount)
    accounting_entries << entry
    entry
  end

  private

  def process(until_date, handle_assets_and_expenses, handle_liabilitites_equity_and_revenue)
    return 0 if accounting_entries.empty?
    filter = date_filter(until_date)
    case category
      when 'Assets', 'Expenses'
        handle_assets_and_expenses.call(filter)
      when 'Liabilities', 'Equity', 'Revenue'
        handle_liabilitites_equity_and_revenue.call(filter)
      else
        0
    end
  end

  def sum_negative_filtered_entries
    Proc.new { |filter| sum_amounts_of(negative_entries_of(filtered_entries(filter))) }
  end

  def sum_positive_filtered_entries
    Proc.new { |filter| sum_amounts_of(positive_entries_of(filtered_entries(filter))) }
  end

  def sum_amounts_of(entries)
    return 0 if entries.empty?
    entries.map { |entry| entry.amount }.reduce(:+)
  end

  def positive_entries_of(entries)
    entries.select { |entry| entry.amount > 0 }
  end

  def negative_entries_of(entries)
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

  #duplicated fix later
  def amount_sign_for_debit
    category_object = Object.const_get(category).new
    category_object.amount_sign_for_debit
    #case category
      #when 'Assets', 'Expenses'
        #1
      #when 'Liabilities', 'Equity', 'Revenue'
        #-1
      #else
        #1
    #end
  end

  #duplicated fix later
  def amount_sign_for_credit
    -1 * amount_sign_for_debit
  end

end
