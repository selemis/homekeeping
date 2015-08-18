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

  def balance(until_date=nil)
    for_non_empty_entries { sum_amounts_of(filtered_entries(date_filter(until_date))) }
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

  def for_non_empty_entries(entries=nil)
    return 0 if (entries ||= accounting_entries).empty?
    yield
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
