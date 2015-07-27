class PayExpense
  attr_accessor :from, :to, :date, :amount
  attr_reader :transaction

  def save
    @transaction = AccountingTransaction.new
    @transaction.book_date = date
    @transaction.credit(from, amount)
    @transaction.debit(to, amount)
    @transaction.save
  end

end
