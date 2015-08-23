module TransactionMakerAsserter

  #TODO this one should be somewhere else
  def create_transaction_type(values)
    values[:type].new(values[:repository]) do |tt|
      tt.from = values[:from_account]
      tt.to = values[:to_account]
      tt.date = values[:book_date]
      tt.amount = values[:amount]
    end
  end


  def from_account_invalid_category(values)
    account_invalid_category(:from, values)
  end

  def to_account_invalid_category(values)
    account_invalid_category(:to, values)
  end

  def create_transaction_maker(values)
    from_account = double('From Account')
    allow(from_account).to receive(:category).and_return(values[:from_account_category])
    to_account = double('To Account')
    allow(to_account).to receive(:category).and_return(values[:to_account_category])
    # from_account = Account.new(name: 'From Account', category: values[:from_account_category])
    # to_account = Account.new(name: 'To Account', category: values[:to_account_category])
    create_transaction_type({
                                type: values[:transaction_maker],
                                from_account: from_account,
                                to_account: to_account,
                                amount: 550,
                                book_date: Date.today
                            })
  end

  private

  def account_invalid_category(attribute, values)
    it values[:message] do
      transaction_maker = create_transaction_maker(values)

      expect(transaction_maker.valid?).to be(false)
      expect(transaction_maker.errors[attribute].any?).to be(true)
      expect(transaction_maker.errors[attribute]).to eq [values[:error_message]]
    end
  end

end
