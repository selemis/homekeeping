require 'spec_helper'

describe AccountingEntry do

  require 'spec_helper'

  describe AccountingEntry do

    context 'having a valid accounting entry' do

      before do
        @accounting_entry = AccountingEntry.new(accounting_entry_attributes)
      end

      it 'has a booking date' do
        expect(@accounting_entry.book_date).to eq accounting_entry_attributes[:book_date]
      end

      it 'has an amount' do
        expect(@accounting_entry.amount).to eq accounting_entry_attributes[:amount]
      end

      it 'is valid with example attributes' do
        expect(@accounting_entry.valid?).to eq true
      end

    end

    it 'it requires a booking date' do
      accounting_entry = AccountingEntry.new

      accounting_entry.valid?

      expect(accounting_entry.errors[:book_date].any?).to eq(true)
    end

    it 'is requires an amount' do
      accounting_entry = AccountingEntry.new

      accounting_entry.valid?

      expect(accounting_entry.errors[:amount].any?).to eq(true)
    end
    
    it 'can belong to an account' do
      account = Account.new(account_attributes)
      entry = AccountingEntry.new(accounting_entry_attributes)
      account.accounting_entries << entry

      expect(entry.account).to eq account
    end

  end

end
