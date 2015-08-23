require 'services/debit_account'
require_relative '../support/entry_bo_assertable'
require 'date'
require 'assets'
require 'liabilities'
require 'equity'
require 'expenses'
require 'revenue'

include EntryBoAssertable

describe DebitAccount do

    before do
      @debit_account = DebitAccount.new
    end

    context 'given the amount is 10 and the booking date it today' do

      before do
        @debit_account.amount = 10
        @debit_account.book_date = Date.today
      end

      it "when the account is 'Assets' category then it creates an accounting entry with positive amount" do
        account = double('Account')
        allow(account).to receive(:category).and_return('Assets')
        @debit_account.account = account

        entry = @debit_account.create_entry

        assert_entry_with_amount(account, entry, 10)
      end

      it "when the account is 'Liabilities' category then it creates an accounting entry with negative amount" do
        account = double('Account')
        allow(account).to receive(:category).and_return 'Liabilities'
        @debit_account.account = account

        entry = @debit_account.create_entry

        assert_entry_with_amount(account, entry, -10)
      end

      it "when the account is 'Equity' category then it creates an accounting entry with negative amount" do
        account = double('Account', category: 'Equity')
        @debit_account.account = account

        entry = @debit_account.create_entry

        assert_entry_with_amount(account, entry, -10)
      end

      it "when the account is 'Expenses' category then it creates an accounting entry with positive amount" do
        account = double('Account')
        allow(account).to receive(:category).and_return('Expenses')
        @debit_account.account = account

        entry = @debit_account.create_entry

        assert_entry_with_amount(account, entry, 10)
      end

      it "when the account is 'Revenue' category then it creates an accounting entry with negative amount" do
        account = double('Account')
        allow(account).to receive(:category).and_return('Revenue')
        @debit_account.account = account

        entry = @debit_account.create_entry

        assert_entry_with_amount(account, entry, -10)
      end

    end

end
