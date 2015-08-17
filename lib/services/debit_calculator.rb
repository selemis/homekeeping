class DebitCalculator
   
  attr_accessor :account

  def calculate_debit(account, until_date=nil)
    @account = account  
    process(until_date) { category_object.calculate_debit }
  end

  def process(until_date)
    for_non_empty_entries do
      summing_block = eval yield, binding
      summing_block.call(date_filter(until_date))
    end
  end
   
  def for_non_empty_entries(entries=nil)
    return 0 if (entries ||= @account.accounting_entries).empty?
    yield
  end

  def category_object
    Object.const_get(@account.category).new
  end

  def sum_positive_filtered_entries
    Proc.new { |filter| sum_amounts_of(positive_entries_of(filtered_entries(filter))) }
  end

  def date_filter(until_date)
    if until_date.nil?
      Proc.new { true }
    else
      Proc.new { |entry| entry.book_date <= until_date }
    end
  end

  def filtered_entries(filter)
    @account.accounting_entries.select { |entry| filter.call(entry) }
  end

  def positive_entries_of(entries)
    entries.select { |entry| entry.amount > 0 }
  end

  def sum_amounts_of(entries)
    for_non_empty_entries(entries) { entries.map { |entry| entry.amount }.reduce(:+) }
  end

  def sum_negative_filtered_entries
    Proc.new { |filter| sum_amounts_of(negative_entries_of(filtered_entries(filter))) }
  end

  def negative_entries_of(entries)
    entries.reject { |entry| entry.amount > 0 }
  end
end
