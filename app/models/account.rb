require 'assets'
require 'equity'
require 'liabilities'
require 'revenue'
require 'expenses'

class Account < ActiveRecord::Base

  CATEGORIES = [Assets.name, Liabilities.name, Equity.name, Revenue.name, Expenses.name]

  has_many :accounting_entries
  validates :name, presence: true
  validates :category, inclusion: {in: CATEGORIES}

  # def balance(until_date=nil)
  #   for_non_empty_entries { sum_amounts_of(filtered_entries(date_filter(until_date))) }
  # end
  #
  # private
  #
  # def for_non_empty_entries(entries=nil)
  #   return 0 if (entries ||= accounting_entries).empty?
  #   yield
  # end

end
