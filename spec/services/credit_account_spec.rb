require 'services/credit_account'
require 'date'
require 'assets'

def assert_entry_with_amount(account, entry, amount)
  expect(entry.amount).to eq amount
  expect(entry.book_date).to eq Date.today
  expect(entry.account).to eq account
end

describe CreditAccount do

  context 'given crediting an account' do

    before do
      @credit_account = CreditAccount.new
    end

    it 'takes an account' do
      account = stub
      @credit_account.account = account

      expect(@credit_account.account).to eq account
    end

    it 'takes a positive amount' do
      @credit_account.amount = 10

      expect(@credit_account.amount).to eq 10
    end

    it 'takes a book date' do
      @credit_account.book_date = Date.today

      expect(@credit_account.book_date).to eq Date.today
    end

    context 'given the amount is 10 and the booking date it today' do

      before do
        @credit_account.amount = 10
        @credit_account.book_date = Date.today
      end

      it "when the account is 'Assets' category then it creates an accounting entry with negative amount" do
        account = stub('Account', category: 'Assets')
        @credit_account.account = account

        entry = @credit_account.credit

        assert_entry_with_amount(account, entry, -10)
      end

      it "when the account is 'Liabilities' category then it creates an accounting entry with positive amount" do
        account = stub('Account', category: 'Liabilities')
        @credit_account.account = account

        entry = @credit_account.credit

        assert_entry_with_amount(account, entry, 10)
      end

      it "when the account is 'Equity' category then it creates an accounting entry with positive amount" do
        account = stub('Account', category: 'Equity')
        @credit_account.account = account

        entry = @credit_account.credit

        assert_entry_with_amount(account, entry, 10)
      end

      it "when the account is 'Expenses' category then it creates an accounting entry with negative amount" do
        account = stub('Account', category: 'Expenses')
        @credit_account.account = account

        entry = @credit_account.credit

        assert_entry_with_amount(account, entry, -10)
      end

      it "when the account is 'Revenue' category then it creates an accounting entry with positive amount" do
        account = stub('Account', category: 'Revenue')
        @credit_account.account = account

        entry = @credit_account.credit

        assert_entry_with_amount(account, entry, 10)
      end

    end

  end

end