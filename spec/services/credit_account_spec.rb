require 'services/credit_account'
require_relative '../support/entry_bo_assertable'
require 'date'
require 'assets'
require 'liabilities'
require 'equity'
require 'expenses'
require 'revenue'

include EntryBoAssertable

describe CreditAccount do

    before do
      @credit_account = CreditAccount.new
    end

    context 'given the amount is 10 and the booking date it today' do

      before do
        @credit_account.amount = 10
        @credit_account.book_date = Date.today
      end

      it "when the account is 'Assets' category then it creates an accounting entry with negative amount" do
        account = stub('Account', category: 'Assets')
        @credit_account.account = account

        entry = @credit_account.create_entry
        assert_entry_with_amount(account, entry, -10)
      end

      it "when the account is 'Liabilities' category then it creates an accounting entry with positive amount" do
        account = stub('Account', category: 'Liabilities')
        @credit_account.account = account

        entry = @credit_account.create_entry

        assert_entry_with_amount(account, entry, 10)
      end

      it "when the account is 'Equity' category then it creates an accounting entry with positive amount" do
        account = stub('Account', category: 'Equity')
        @credit_account.account = account

        entry = @credit_account.create_entry

        assert_entry_with_amount(account, entry, 10)
      end

      it "when the account is 'Expenses' category then it creates an accounting entry with negative amount" do
        account = stub('Account', category: 'Expenses')
        @credit_account.account = account

        entry = @credit_account.create_entry

        assert_entry_with_amount(account, entry, -10)
      end

      it "when the account is 'Revenue' category then it creates an accounting entry with positive amount" do
        account = stub('Account', category: 'Revenue')
        @credit_account.account = account

        entry = @credit_account.create_entry

        assert_entry_with_amount(account, entry, 10)
      end

    end

end
