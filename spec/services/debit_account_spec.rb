require 'services/debit_account'

def assert_entry_with_amount(account, entry, amount)
  expect(entry.amount).to eq amount
  expect(entry.book_date).to eq Date.today
  expect(entry.account).to eq account
end

describe DebitAccount do

  context 'given debiting an account' do

    before do
      @debit_account = DebitAccount.new
    end

    it 'takes an account' do
      account = stub
      @debit_account.account = account

      expect(@debit_account.account).to eq account
    end

    it 'takes a positive amount' do
      @debit_account.amount = 10

      expect(@debit_account.amount).to eq 10
    end

    it 'takes a book date' do
      @debit_account.book_date = Date.today

      expect(@debit_account.book_date).to eq Date.today
    end

    context 'given the amount is 10 and the booking date it today' do

      before do
        @debit_account.amount = 10
        @debit_account.book_date = Date.today
      end

      it "when the account is 'Assets' category then it creates an accounting entry with positive amount" do
        account = stub('Account', category: 'Assets')
        @debit_account.account = account

        entry = @debit_account.create_entry

        assert_entry_with_amount(account, entry, 10)
      end

      it "when the account is 'Liabilities' category then it creates an accounting entry with negative amount" do
        account = stub('Account', category: 'Liabilities')
        @debit_account.account = account

        entry = @debit_account.create_entry

        assert_entry_with_amount(account, entry, -10)
      end

      it "when the account is 'Equity' category then it creates an accounting entry with negative amount" do
        account = stub('Account', category: 'Equity')
        @debit_account.account = account

        entry = @debit_account.create_entry

        assert_entry_with_amount(account, entry, -10)
      end

      it "when the account is 'Expenses' category then it creates an accounting entry with positive amount" do
        account = stub('Account', category: 'Expenses')
        @debit_account.account = account

        entry = @debit_account.create_entry

        assert_entry_with_amount(account, entry, 10)
      end

      it "when the account is 'Revenue' category then it creates an accounting entry with negative amount" do
        account = stub('Account', category: 'Revenue')
        @debit_account.account = account

        entry = @debit_account.create_entry

        assert_entry_with_amount(account, entry, -10)
      end

    end

  end

end