require 'services/calculator'

class CreditCalculator
  
  include Calculator  
   
  attr_accessor :account

  def calculate_credit(account, until_date=nil)
    @account = account
    process(until_date) { category_object.calculate_credit }
  end

end

