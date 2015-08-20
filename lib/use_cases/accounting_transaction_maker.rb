class AccountingTransactionMaker
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
      @transaction.book_date = date
      @transaction.accounting_entries << action(CreditAccount.new, from, amount)
      @transaction.accounting_entries << action(DebitAccount.new, to, amount)
      @transaction.save
    else
      raise exception_message
    end
  end
  
  private

  def action(operation, account, amount)
    operation.account = account
    operation.book_date = date
    operation.amount = amount
    entry = operation.create_entry
    accounting_entry = AccountingEntry.new(book_date: entry.book_date, amount: entry.amount)
    account.accounting_entries << accounting_entry
    accounting_entry
  end

end
