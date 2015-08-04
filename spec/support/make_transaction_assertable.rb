module MakeTransactionAssertable

  #TODO this one should be somewhere else
  def create_transaction_type(values)
    values[:type].new do |tt|
      tt.from = values[:from_account]
      tt.to = values[:to_account]
      tt.date = values[:book_date]
      tt.amount = values[:amount]
    end
  end

  def assert_transaction(values)
    trans = values[:transaction]
    entry1 = trans.accounting_entries.select { |entry| entry.account == values[:from_account] }.first
    entry2 = trans.accounting_entries.select { |entry| entry.account == values[:to_account] }.first
    expect(trans.valid?).to be_true
    expect(trans.accounting_entries.size).to eq 2
    expect(entry1.amount).to eq values[:from_amount]
    expect(entry2.amount).to eq values[:to_amount]
  end

  def basic_validation(context_message, make_transaction_type)

    context context_message do

      before do
        @transaction_maker = make_transaction_type.new
        @transaction_maker.valid?
      end

      it 'then it requires a book date' do
        expect(@transaction_maker.errors[:date].any?).to be_true
      end

      it 'then it requires a from account' do
        expect(@transaction_maker.errors[:from].any?).to be_true
      end

      it 'then it requires a to account' do
        expect(@transaction_maker.errors[:to].any?).to be_true
      end

      it 'then it requires an amount' do
        expect(@transaction_maker.errors[:amount].any?).to be_true
      end

    end

  end

  def from_account_invalid_category(values)

    it values[:message] do
      from_account = Account.new(name: 'From Account', category: values[:from_account_category])
      to_account = Account.new(name: 'To Account', category: values[:to_account_category])
      transaction_maker = create_transaction_type({
                                        type: values[:transaction_maker],
                                        from_account: from_account,
                                        to_account: to_account,
                                        amount: 550,
                                        book_date: Date.today
                                    })

      expect(transaction_maker.valid?).to be_false

      expect(transaction_maker.errors[:from].any?).to be_true
      expect(transaction_maker.errors[:from]).to eq [values[:error_message]]
    end

  end



end
