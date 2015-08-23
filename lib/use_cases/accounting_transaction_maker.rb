require 'active_model/validations'
require 'business_objects/accounting_transaction_bo'
require 'services/credit_account'
require 'services/debit_account'
require 'assets'
require 'expenses'

class AccountingTransactionMaker
  include ActiveModel::Validations

 attr_accessor :from, :to, :date, :amount
 attr_reader :transaction

  validates_presence_of :date, :from, :to, :amount

  def initialize(repository)
    @repository = repository  
    yield self if block_given?
  end

  def save
    if valid?
      @transaction = AccountingTransactionBo.new(@repository)
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
    operation.create_entry
  end

end
