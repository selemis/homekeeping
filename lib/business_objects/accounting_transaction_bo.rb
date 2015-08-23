class AccountingTransactionBo
  attr_accessor :book_date
  attr_accessor :accounting_entries
  
  def initialize(repository)
    @accounting_entries = Array.new
    @repository=repository
  end

  def valid?
    @repository.valid?  
  end

  def save
    @repository.save
  end

end

