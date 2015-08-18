require 'services/debit_calculator'
require 'assets'
require 'liabilities'
require 'equity'
require 'revenue'
require 'expenses'

def date_from(string_format)
  Date.strptime(string_format, '%d-%m-%Y')
end

describe DebitCalculator do

  it 'has a zero debit if the account has no entries' do
    account = stub('Account', accounting_entries: Array.new)
    expect(DebitCalculator.new.calculate_debit(account)).to eq 0
  end

  it 'calculates debits if the account has only debits' do
    positive_entry = stub('Entry', amount: 12.34, empty?: false)
    account = stub('account', accounting_entries: [positive_entry], category: 'Assets')

    expect(DebitCalculator.new.calculate_debit(account)).to eq 12.34
  end

  it 'has a zero debit if the account has only credits' do
    negative_entry = stub('Entry', amount: -50, empty?: false)
    account = stub('Account', accounting_entries: [negative_entry], category: 'Assets')

    expect(DebitCalculator.new.calculate_debit(account)).to eq 0
  end

  context 'Given a list of accounting entries' do

    before do
      @entries = [
          stub('Entry1', book_date: date_from('01-01-2015'), amount: 100.50),
          stub('Entry2', book_date: date_from('01-01-2015'), amount: -20.50),
          stub('Entry3', book_date: date_from('02-01-2015'), amount: 10),
          stub('Entry4', book_date: date_from('03-01-2015'), amount: -30),
          stub('Entry5', book_date: date_from('04-01-2015'), amount: 40.20)
      ]
    end

    context "when having an 'Assets' account" do

      before do
        @account = stub('account', accounting_entries: @entries, category: 'Assets')
      end

      it 'sums positive amounts as debits' do
        expect(DebitCalculator.new.calculate_debit(@account)).to eq 150.70
      end

      it 'calculates debits until a date' do
        expect(DebitCalculator.new.calculate_debit(@account, date_from('02-01-2015'))).to eq 110.50
      end

    end

    context "when having a 'Liabilities' account" do

      before do
        @account = stub('account', accounting_entries: @entries, category: 'Liabilities')
      end

      it 'sums negative amounts as debits' do
        expect(DebitCalculator.new.calculate_debit(@account)).to eq -50.50
      end

      it 'calculates debits until a date' do
        expect(DebitCalculator.new.calculate_debit(@account, date_from('02-01-2015'))).to eq -20.50
      end

    end

    context "when having an 'Equity' account" do

      before do
        @account = stub('account', accounting_entries: @entries, category: 'Equity')
      end

      it 'sums negative amounts as debits' do
        expect(DebitCalculator.new.calculate_debit(@account)).to eq -50.50
      end

      it 'calculates debits until a date' do
        expect(DebitCalculator.new.calculate_debit(@account, date_from('02-01-2015'))).to eq -20.50
      end

    end

    context "when having a 'Revenue' account" do

      before do
        @account = stub('account', accounting_entries: @entries, category: 'Revenue')
      end

      it 'sums negative amounts as debits' do
        expect(DebitCalculator.new.calculate_debit(@account)).to eq -50.50
      end

      it 'calculates debits until a date' do
        expect(DebitCalculator.new.calculate_debit(@account, date_from('02-01-2015'))).to eq -20.50
      end

    end

    context "when having an 'Expenses' account" do

      before do
        @account = stub('account', accounting_entries: @entries, category: 'Expenses')
      end

      it 'sums positive amounts as debits' do
        expect(DebitCalculator.new.calculate_debit(@account)).to eq 150.70
      end

      it 'calculates debits until a date' do
        expect(DebitCalculator.new.calculate_debit(@account, date_from('02-01-2015'))).to eq 110.50
      end

    end

  end

end
