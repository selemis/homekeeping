require 'active_model'
require 'use_cases/accounting_transaction_maker'

describe AccountingTransactionMaker do

  context 'when it is initialized and checked for validation' do

    before do
      repository = double('repository')
      @transaction_maker = AccountingTransactionMaker.new(repository)
      @transaction_maker.valid?
    end

    it 'then it requires a book date' do
      expect(@transaction_maker.errors[:date].any?).to be(true)
    end

    it 'then it requires a from account' do
      expect(@transaction_maker.errors[:from].any?).to be(true)
    end

    it 'then it requires a to account' do
      expect(@transaction_maker.errors[:to].any?).to be(true)
    end

    it 'then it requires an amount' do
      expect(@transaction_maker.errors[:amount].any?).to be(true)
    end

  end

  context 'when saving a valid accounting transaction maker' do

    before do
      @repository = double('repository')
      from = double('from', category: 'Assets')
      to = double('to', category: 'Assets')
      @transaction_maker = AccountingTransactionMaker.new(@repository)
      @transaction_maker.from = from
      @transaction_maker.to = to
      @transaction_maker.amount = 10
      @transaction_maker.date = Date.today

    end

    it 'creates an accounting transaction and it saves it' do
      expect(@repository).to receive(:save)
      @transaction_maker.save

      trans = @transaction_maker.transaction
      entry1 = trans.accounting_entries.select { |entry| entry.account == @transaction_maker.from }.first
      entry2 = trans.accounting_entries.select { |entry| entry.account == @transaction_maker.to }.first
      expect(trans.accounting_entries.size).to eq 2
      expect(entry1.amount).to eq -10
      expect(entry2.amount).to eq 10
    end

  end

  context 'when saving an invalid accounting transaction maker' do

    before do
      @repository = double('repository')
      @transaction_maker = AccountingTransactionMaker.new(@repository)
      def @transaction_maker.exception_message
        'not valid'
      end
    end

    it 'raises an exception message' do
      expect { @transaction_maker.save }.to raise_error(RuntimeError, 'not valid')
    end
  end

end
