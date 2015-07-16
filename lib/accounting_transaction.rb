class AccountingTransaction

  def initialize
    @credits = Hash.new
    @debits = Hash.new
  end
   
  def credit(account, amount)
    @credits[account] = amount
  end

  def debit(account, amount)
    @debits[account] = amount
  end

  def place

    #TODO change date
    #TODO remember to save
    @credits.each do |account, amount|
      amount_with_sign = amount_sign_for_credit(account) * amount
      entry = AccountingEntry.new(book_date: Date.today, amount: amount_with_sign)
      account.accounting_entries << entry
    end
  
    @debits.each do |account, amount|
      amount_with_sign = amount_sign_for_debit(account) * amount
      entry = AccountingEntry.new(book_date: Date.today, amount: amount_with_sign)
      account.accounting_entries << entry
    end

  end

  private

  #duplicated fix later
  def amount_sign_for_debit(account)
    case account.category
      when 'Assets', 'Expenses'
        1
      when 'Liabilities', 'Equity', 'Revenue'
        -1
      else
        1
    end
  end

  #duplicated fix later
  def amount_sign_for_credit(account)
    -1 * amount_sign_for_debit(account)
  end

end
