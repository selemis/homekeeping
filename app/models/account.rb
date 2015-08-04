class Account < ActiveRecord::Base

  CATEGORIES = [Assets.name, Liabilities.name, Equity.name, Revenue.name, Expenses.name]

  has_many :accounting_entries
  validates :name, presence: true
  validates :category, inclusion: {in: CATEGORIES}

  def balance(until_date=nil)
    for_non_empty_entries { sum_amounts_of(filtered_entries(date_filter(until_date))) }
  end

  def calculate_debit(until_date=nil)
    process(until_date) { category_object.calculate_debit }
  end

  def calculate_credit(until_date=nil)
    process(until_date) { category_object.calculate_credit }
  end

  def credit(amount, book_date)
    transaction_with_sign(amount, book_date) { amount_sign_for_credit }
  end

  def debit(amount, book_date)
    transaction_with_sign(amount, book_date) { amount_sign_for_debit }
  end

  private

  def transaction_with_sign(amount, book_date)
    entry = AccountingEntry.new(book_date: book_date, amount: yield * amount)
    accounting_entries << entry
    entry
  end

  def process(until_date)
    for_non_empty_entries do
      summing_block = eval yield, binding
      summing_block.call(date_filter(until_date))
    end
  end

  def for_non_empty_entries(entries=nil)
    return 0 if (entries ||= accounting_entries).empty?
    yield
  end

  def sum_negative_filtered_entries
    Proc.new { |filter| sum_amounts_of(negative_entries_of(filtered_entries(filter))) }
  end

  def sum_positive_filtered_entries
    Proc.new { |filter| sum_amounts_of(positive_entries_of(filtered_entries(filter))) }
  end

  def sum_amounts_of(entries)
    for_non_empty_entries(entries) { entries.map { |entry| entry.amount }.reduce(:+) }
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

  def amount_sign_for_debit
    category_object.amount_sign_for_debit
  end

  def amount_sign_for_credit
    -1 * amount_sign_for_debit
  end

  def category_object
    Object.const_get(category).new
  end

end
