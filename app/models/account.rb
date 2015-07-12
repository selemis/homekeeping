class Account < ActiveRecord::Base
  has_many :accounting_entries

  validates :name, presence: true

  def balance
    return 0 if accounting_entries.empty?
    accounting_entries.map{|entry| entry.amount}.reduce(:+)
  end

end
