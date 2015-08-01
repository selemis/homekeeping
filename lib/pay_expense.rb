require_relative 'asset_or_liabilities_validator'
class PayExpense

  include ActiveModel::Validations

  attr_accessor :from, :to, :date, :amount
  attr_reader :transaction

  validates_presence_of :date, :from, :to, :amount
  validates :from, asset_or_liabilities:  true

  def initialize
    yield self if block_given?
  end

  def save
    @transaction = AccountingTransaction.new
    @transaction.book_date = date
    @transaction.credit(from, amount)
    @transaction.debit(to, amount)
    @transaction.save
  end

end
