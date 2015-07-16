require 'accounting_transaction'
describe 'placing an accounting transaction' do
  
  context 'salary payment with cash' do

    it 'credits the salary account with an amount and debits the cash account with the same amount' do
      #TODO remember booking date
       
      salary = Account.new(name: 'Salary', category: 'Revenue')
      cash = Account.new(name: 'Cash', category: 'Assets')

      transaction = AccountingTransaction.new
      transaction.credit(salary, 100)
      transaction.debit(cash, 100)
      transaction.place

      expect(salary.accounting_entries.size).to eq 1
      expect(cash.accounting_entries.size).to eq 1
      expect(salary.credit).to eq 100
      expect(cash.debit).to eq 100
    end

  end

  context 'Withdraw money from bank' do
    
    it 'debits the salary account with an amount and credits the savings account with the same amount' do

      cash = Account.new(name: 'Cash', category: 'Assets')
      savings_account = Account.new(name: 'Savings Account', category: 'Assets')

      transaction = AccountingTransaction.new
      transaction.credit(savings_account, 100)
      transaction.debit(cash, 100)
      transaction.place

      expect(savings_account.accounting_entries.size).to eq 1
      expect(cash.accounting_entries.size).to eq 1
      expect(cash.debit).to eq 100
      expect(savings_account.credit).to eq -100

    end
  
  end


end

