require'validators/asset_or_liabilities_validator'
require 'validators/expenses_validator'

class PayExpense

  include ActiveModel::Validations

  attr_accessor :from, :to, :date, :amount
  attr_reader :transaction

  validates_presence_of :date, :from, :to, :amount
  validates :from, asset_or_liabilities: true
  validates :to, expenses: true

  def initialize
    yield self if block_given?
  end

  def save
    if valid?
      @transaction = AccountingTransaction.new
      @transaction.book_date = date
      @transaction.credit(from, amount)
      @transaction.debit(to, amount)
      @transaction.save
    else
      raise 'The expense payment is not valid'
    end

  end

end
