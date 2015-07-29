class PayExpense
  attr_accessor :from, :to, :date, :amount
  attr_reader :transaction

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
