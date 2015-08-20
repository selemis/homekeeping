require 'services/calculator'

class DebitCalculator

  include Calculator  
   
  attr_accessor :account

  def calculate_debit(account, until_date=nil)
    @account = account  
    process(until_date) { category_object.calculate_debit }
  end

end
