require 'spec_helper'

describe AccountingTransaction do

  it 'has entries' do
    trans = AccountingTransaction.new
    entry1 = AccountingEntry.new(accounting_entry_attributes({amount: 100}))
    entry2 = AccountingEntry.new(accounting_entry_attributes({amount: -100}))
    trans.accounting_entries << entry1 << entry2

    expect(trans.accounting_entries.size).to eq 2
    expect(trans.accounting_entries.first).to eq entry1
    expect(trans.accounting_entries.second).to eq entry2
  end

  it 'has a book date' do
    trans = AccountingTransaction.new
    trans.book_date = Date.today

    expect(trans.book_date).to eq Date.today
  end

  context 'is valid' do
  
    context 'requires at least 2 entries' do
        
      before do
        @trans = AccountingTransaction.new
      end

      it 'is not valid if it has no entries' do
        @trans.valid?
  
        expect(@trans.errors[:accounting_entries_size].any?).to eq(true)
      end
    
      context 'it has one accounting entry' do

        before do
          entry = AccountingEntry.new(accounting_entry_attributes)
          @trans.accounting_entries << entry
        end

        it 'is not valid if it has one entry' do
          @trans.valid?
    
          expect(@trans.errors[:accounting_entries_size].any?).to eq(true)
        end

        context 'it has two accounting entries' do
          
          before do
            entry = AccountingEntry.new(accounting_entry_attributes({amount: accounting_entry_attributes[:amount] * -1}))
            @trans.accounting_entries << entry
          end

          it 'is valid if it has two accounting entries' do
            @trans.valid?

            expect(@trans.errors[:accounting_entries_size].any?).to eq(false)
          end

        end

      end

    end
    
    it 'it requires a booking date' do
      trans = AccountingTransaction.new

      trans.valid?

      expect(trans.errors[:book_date].any?).to eq(true)
    end
    
    xit 'requires the credits to be equal to debits' do

      cash = Account.new(name: 'Cash', category: 'Assets')
      savings_account = Account.new(name: 'Savings Account', category: 'Assets')
      transaction = AccountingTransaction.new
      transaction.book_date = Date.today
      credit_entry = AccountingEntry.new(book_date: Date.today, amount: -100)
      debit_entry = AccountingEntry.new(book_date: Date.today, amount: 100)

      credit_entry.account = savings_account
      debit_entry.account = cash

      transaction.accounting_entries << credit_entry
      transaction.accounting_entries << debit_entry

      credits = transaction.accounting_entries.map {|entry| entry.account.credit}.reduce(:+)
      puts transaction.accounting_entries.map {|entry| entry.account.accounting_entries.size}
      debits = transaction.accounting_entries.map {|entry| entry.account.debit}.reduce(:+)

      expect(credits).to eq 100
      expect(debits).to eq 100

      
     # transaction.credit(savings_account, 100)
     # transaction.debit(cash, 100)
    
    end

    it 'the transaction book date must be the same as the booking dates of all its entries'
  
  end

end

