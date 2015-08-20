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

end
