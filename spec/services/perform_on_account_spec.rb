require 'services/perform_on_account'

describe PerformOnAccount do

    before do
      @perform_on_account = PerformOnAccount.new
    end

    it 'takes an account' do
      account = double
      @perform_on_account.account = account

      expect(@perform_on_account.account).to eq account
    end

    it 'takes a positive amount' do
      @perform_on_account.amount = 10

      expect(@perform_on_account.amount).to eq 10
    end

    it 'takes a book date' do
      @perform_on_account.book_date = Date.today

      expect(@perform_on_account.book_date).to eq Date.today
    end

end

