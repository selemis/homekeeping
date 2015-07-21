module AccountAssertable

  def assert_positive_debits_negative_credits

    it 'sums positive amounts as debits' do
      expect(@account.calculate_debit).to eq 150.70
    end
  
    it 'sums negative amounts as credits' do
      expect(@account.calculate_credit).to eq -50.50
    end
  
    it 'calculates debits until a date' do
      expect(@account.calculate_debit(date_from('02-01-2015'))).to eq 110.50
    end
  
    it 'calculates credits until a date' do
      expect(@account.calculate_credit(date_from('02-01-2015'))).to eq -20.50
    end
  
  end
  
  def assert_positive_credits_negative_debits
  
    it 'sums positive amounts as credits' do
      expect(@account.calculate_credit).to eq 150.70
    end
  
    it 'sums negative amounts as debits' do
      expect(@account.calculate_debit).to eq -50.50
    end
  
    it  'calculates credits until a date' do
      expect(@account.calculate_credit(date_from('02-01-2015'))).to eq 110.50
    end
  
    it  'calculates debits until a date' do
      expect(@account.calculate_debit(date_from('02-01-2015'))).to eq -20.50
    end
  
  end
end

