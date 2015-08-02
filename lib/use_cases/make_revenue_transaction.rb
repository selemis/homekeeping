require 'validators/revenue_validator'
require 'validators/asset_validator'

class MakeRevenueTransaction

  include ActiveModel::Validations

  attr_accessor :from, :to, :date, :amount
  attr_reader :transaction

  validates_presence_of :date, :from, :to, :amount
  validates :from, revenue: true
  validates :to, asset: true


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
      raise 'The revenue transaction is not valid'
    end

  end


end