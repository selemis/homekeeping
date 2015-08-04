require 'spec_helper'
require 'use_cases/asset_to_asset_transaction'
require_relative '../support/make_transaction_assertable'

include MakeTransactionAssertable

describe "Making an 'Assets' to 'Assets' transaction " do

  it 'when I deposit 100 value of cash to savings account, then it creates an entry of -100 for cash and an entry of 100 for savings account' do
    cash = Account.new(name: 'Cash', category: 'Assets')
    savings_account = Account.new(name: 'Savings Account', category: 'Assets')

    deposit = create_transaction_type({
                                          type: AssetToAssetTransaction,
                                          book_date: Date.today,
                                          from_account: cash,
                                          to_account: savings_account,
                                          amount: 1000
                                      })

    deposit.save

    assert_payment({
                       transaction: deposit.transaction,
                       book_date: Date.today,
                       from_account: cash, from_amount: -1000,
                       to_account: savings_account, to_amount: 1000
                   })

  end

  context "Given a new 'Assets' to 'Assets' transaction, when checking for validation" do

    before do
      @make_trans = AssetToAssetTransaction.new
      @make_trans.valid?
    end

    it 'then it requires a book date' do
      expect(@make_trans.errors[:date].any?).to be_true
    end

    it 'then it requires a from account' do
      expect(@make_trans.errors[:from].any?).to be_true
    end

    it 'then it requires a to account' do
      expect(@make_trans.errors[:to].any?).to be_true
    end

    it 'then it requires an amount' do
      expect(@make_trans.errors[:amount].any?).to be_true
    end

  end

  context "given an 'Assets' to 'Assets' transaction with a from category not 'Assets' " do

    before do
      credit_card = Account.new(name: 'Credit Card', category: 'Liabilities')
      savings_account = Account.new(name: 'Savings Account', category: 'Assets')

      @deposit = create_transaction_type({
                                             type: AssetToAssetTransaction,
                                             book_date: Date.today,
                                             from_account: credit_card,
                                             to_account: savings_account,
                                             amount: 1000
                                         })

    end

    it  'when checking for validation then an error occurs for the from account' do
      expect(@deposit.valid?).to be_false
      expect(@deposit.errors[:from].any?).to be_true
      expect(@deposit.errors[:from]).to eq ['The from account category is not Assets']
    end

    it 'when saving the transaction then it raises an exception' do
      expect { @deposit.save }.to raise_error(RuntimeError, 'The asset transaction is not valid')
    end

  end

  it "given 'Assets' to 'Assets' transaction with a to account category not 'Assets' when checking for validation then an errors occurs for the to account" do
    savings_account = Account.new(name: 'Savings Account', category: 'Assets')
    credit_card = Account.new(name: 'Credit Card', category: 'Liabilities')

    deposit = create_transaction_type({
                                           type: AssetToAssetTransaction,
                                           book_date: Date.today,
                                           from_account: savings_account,
                                           to_account: credit_card,
                                           amount: 1000
                                       })
    expect(deposit.valid?).to be_false
    expect(deposit.errors[:to].any?).to be_true
    expect(deposit.errors[:to]).to eq ['The to account category is not Assets']
  end

end