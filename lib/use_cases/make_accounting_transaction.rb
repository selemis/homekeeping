class MakeAccountingTransaction
  include ActiveModel::Validations

  attr_accessor :from, :to, :date, :amount
  attr_reader :transaction

  validates_presence_of :date, :from, :to, :amount

  def initialize
    yield self if block_given?
  end

  def save
    if valid?
      @transaction = AccountingTransaction.new
      puts "DATE: #{date}"
      @transaction.book_date = date
      @transaction.credit(from, amount)
      @transaction.debit(to, amount)
      @transaction.save
    else
      raise exception_message
    end
  end

end
