require 'services/credit_calculator'
require 'assets'
require 'liabilities'
require 'equity'
require 'revenue'
require 'expenses'

def date_from(string_format)
  Date.strptime(string_format, '%d-%m-%Y')
end

describe CreditCalculator do

  it 'has zero credit if the account  has no entries' do
    account = double('account', accounting_entries: Array.new)
    expect(CreditCalculator.new.calculate_credit(account)).to eq 0
  end

  it 'has a zero credit if the account has only debits' do
    positive_entry = double('Entry', amount: 12.34, empty?: false)
    account = double('account', accounting_entries: [positive_entry], category: 'Assets')

    expect(CreditCalculator.new.calculate_credit(account)).to eq 0
  end

  it 'calculates credit for an account with only credit entries' do
    negative_entry = double('Entry', amount: -50, empty?: false)
    account = double('Account', accounting_entries: [negative_entry], category: 'Assets')

    expect(CreditCalculator.new.calculate_credit(account)).to eq -50
  end

  context 'Given a list of accounting entries' do

    before do
      @entries = [
          double('Entry1', book_date: date_from('01-01-2015'), amount: 100.50),
          double('Entry2', book_date: date_from('01-01-2015'), amount: -20.50),
          double('Entry3', book_date: date_from('02-01-2015'), amount: 10),
          double('Entry4', book_date: date_from('03-01-2015'), amount: -30),
          double('Entry5', book_date: date_from('04-01-2015'), amount: 40.20)
      ]
    end

    context "when having an 'Assets' account" do

      before do
        @account = double('account', accounting_entries: @entries, category: 'Assets')
      end

      it 'sums negative amounts as credits' do
        expect(CreditCalculator.new.calculate_credit(@account)).to eq -50.50
      end

      it 'calculates credits until a date' do
        expect(CreditCalculator.new.calculate_credit(@account, date_from('02-01-2015'))).to eq -20.50
      end

    end

    context "when having 'Liabilities' account" do

      before do
        @account = double('account', accounting_entries: @entries, category: 'Liabilities')
      end

      it 'sums positive amounts as credits' do
        expect(CreditCalculator.new.calculate_credit(@account)).to eq 150.70
      end

      it 'calculates credits until a date' do
        expect(CreditCalculator.new.calculate_credit(@account, date_from('02-01-2015'))).to eq 110.50
      end

    end

    context "when having an 'Equity' account" do

      before do
        @account = double('account', accounting_entries: @entries, category: 'Equity')
      end

      it 'sums positive amounts as credits' do
        expect(CreditCalculator.new.calculate_credit(@account)).to eq 150.70
      end

      it 'calculates credits until a date' do
        expect(CreditCalculator.new.calculate_credit(@account, date_from('02-01-2015'))).to eq 110.50
      end

    end

    context "when having a 'Revenue' account" do

      before do
        @account = double('account', accounting_entries: @entries, category: 'Revenue')
      end

      it 'sums positive amounts as credits' do
        expect(CreditCalculator.new.calculate_credit(@account)).to eq 150.70
      end

      it 'calculates credits until a date' do
        expect(CreditCalculator.new.calculate_credit(@account, date_from('02-01-2015'))).to eq 110.50
      end

    end

    context "when having an 'Expenses' account" do

      before do
        @account = double('account', accounting_entries: @entries, category: 'Expenses')
      end

      it 'sums negative amounts as credits' do
        expect(CreditCalculator.new.calculate_credit(@account)).to eq -50.50
      end

      it 'calculates credits until a date' do
        expect(CreditCalculator.new.calculate_credit(@account, date_from('02-01-2015'))).to eq -20.50
      end

    end

  end

end
