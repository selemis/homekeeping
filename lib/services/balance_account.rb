class BalanceAccount

  def balance(account, date_from=nil, date_to=nil)

    entries = get_entries(account, date_from, date_to)

    if entries.empty?
      0
    else
      entries.map{|entry| entry.amount}.reduce(:+)
    end
  end

  def get_entries(account, date_from, date_to)
    if date_from.nil? or date_to.nil?
      entries = account.accounting_entries
    else
      entries = account.accounting_entries.select { |entry| entry.book_date <= date_to and entry.book_date >= date_from }
    end
    entries
  end

end