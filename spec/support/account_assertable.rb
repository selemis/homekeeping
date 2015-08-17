require 'services/debit_calculator'
require 'services/credit_calculator'

module AccountAssertable

  def assert_positive_debits_negative_credits

    it 'sums positive amounts as debits' do
      calculator = DebitCalculator.new  
      expect(calculator.calculate_debit(@account)).to eq 150.70
    end
  
    it 'sums negative amounts as credits' do
      calculator = CreditCalculator.new  
      expect(calculator.calculate_credit(@account)).to eq -50.50
    end
  
    it 'calculates debits until a date' do
      calculator = DebitCalculator.new  
      expect(calculator.calculate_debit(@account, date_from('02-01-2015'))).to eq 110.50
    end
  
    it 'calculates credits until a date' do
      calculator = CreditCalculator.new  
      expect(calculator.calculate_credit(@account,date_from('02-01-2015'))).to eq -20.50
    end
  
  end
  
  def assert_positive_credits_negative_debits
  
    it 'sums positive amounts as credits' do
      calculator = CreditCalculator.new  
      expect(calculator.calculate_credit(@account)).to eq 150.70
    end
  
    it 'sums negative amounts as debits' do
      calculator = DebitCalculator.new  
      expect(calculator.calculate_debit(@account)).to eq -50.50
    end
  
    it  'calculates credits until a date' do
      calculator = CreditCalculator.new  
      expect(calculator.calculate_credit(@account,date_from('02-01-2015'))).to eq 110.50
    end
  
    it  'calculates debits until a date' do
      calculator = DebitCalculator.new  
      expect(calculator.calculate_debit(@account, date_from('02-01-2015'))).to eq -20.50
    end
  
  end
end

