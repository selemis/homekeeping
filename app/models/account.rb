class Account < ActiveRecord::Base
  has_many :accounting_entries

  validates :name, presence: true

  def balance(until_date=nil)
    return 0 if accounting_entries.empty?
    filter = date_filter(until_date)
    accounting_entries
                .select{ |entry| filter.call(entry) }
                .map{ |entry| entry.amount}
                .reduce(:+)
  end

  private

  def date_filter(until_date)
    if until_date.nil?
      Proc.new {|entry| true}
    else
      Proc.new {|entry| entry.book_date <= until_date}
    end
  end

end
