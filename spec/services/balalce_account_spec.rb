require 'services/balance_account'

def date_from(string_format)
  Date.strptime(string_format, '%d-%m-%Y')
end

describe BalanceAccount do

  before do
    @balancer = BalanceAccount.new
  end

  it 'when account has no entries then it is zero' do
    account = double('Account', accounting_entries: [])

    balance = @balancer.balance(account)

    expect(balance).to eq 0
  end

  context 'Given an account with accounting entries' do

    before do
      accounting_entries = [
          double('Entry1', book_date: date_from('01-01-2015'), amount: 100.50),
          double('Entry2', book_date: date_from('01-01-2015'), amount: -20.50),
          double('Entry3', book_date: date_from('02-01-2015'), amount: 10),
          double('Entry4', book_date: date_from('03-01-2015'), amount: -30),
          double('Entry5', book_date: date_from('04-01-2015'), amount: 40.20)
      ]
      @account = double('Account', accounting_entries: accounting_entries)
    end

    it 'sums all the entries for an account' do
      balance = @balancer.balance(@account)

      expect(balance).to eq 100.20
    end

    it 'sums all the entries for an account for a period of time' do
      balance = @balancer.balance(@account, date_from('02-01-2015'), date_from('03-01-2015'))

      expect(balance).to eq -20
    end

  end

end