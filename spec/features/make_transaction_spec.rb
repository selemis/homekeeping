require 'accounting_transaction'
describe 'placing an accounting transaction' do
  
  before do
      Account.delete_all
  end

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
      expect(transaction.valid?).to be_true

      transaction.commit

      cash_db = Account.find_by(name: 'Cash')
      expect(cash_db.name).to eq 'Cash'
      expect(cash_db.accounting_entries.size).to eq 1
      expect(cash_db.debit).to eq 100
      expect(cash_db.credit).to eq 0

      salary_db = Account.find_by(name: 'Salary')
      expect(salary_db.name).to eq 'Salary'
      expect(salary_db.accounting_entries.size).to eq 1
      expect(salary_db.debit).to eq 0
      expect(salary_db.credit).to eq 100

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
      expect(transaction.valid?).to be_true

      transaction.commit

      cash_db = Account.find_by(name: 'Cash')
      expect(cash_db.name).to eq 'Cash'
      expect(cash_db.accounting_entries.size).to eq 1
      expect(cash_db.debit).to eq 100
      expect(cash_db.credit).to eq 0

      savings_account_db = Account.find_by(name: 'Savings Account')
      expect(savings_account_db.name).to eq 'Savings Account'
      expect(savings_account_db.accounting_entries.size).to eq 1
      expect(savings_account_db.debit).to eq 0
      expect(savings_account_db.credit).to eq -100

    end
  
  end

  context 'Pay for food with cash' do

    it 'credits the cash account and debits the groceries account with the same amount' do
      cash = Account.new(name: 'Cash', category: 'Assets')
      groceries = Account.new(name: 'Groceries', category: 'Expenses')

      transaction = AccountingTransaction.new
      transaction.credit(cash, 50)
      transaction.debit(groceries, 50)
      transaction.place

      expect(groceries.accounting_entries.size).to eq 1
      expect(cash.accounting_entries.size).to eq 1
      expect(groceries.debit).to eq 50
      expect(cash.credit).to eq -50
      expect(transaction.valid?).to be_true

      transaction.commit

      puts Account.all.size

      cash_db = Account.find_by(name: 'Cash')
      expect(cash_db.name).to eq 'Cash'
      expect(cash_db.accounting_entries.size).to eq 1
      expect(cash_db.debit).to eq 0
      expect(cash_db.credit).to eq -50

      groceries_db = Account.find_by(name: 'Groceries')
      expect(groceries_db.name).to eq 'Groceries'
      expect(groceries_db.accounting_entries.size).to eq 1
      expect(groceries_db.debit).to eq 50
      expect(groceries_db.credit).to eq 0
    end

  end

  after do
    Account.delete_all
  end

end

