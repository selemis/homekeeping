require 'spec_helper'
require 'use_cases/pay_expense'

include MakeTransactionAssertable

describe 'Making an expense payment' do

  context 'given paying groceries of value 100 with cash' do

    it 'when making the payment then it creates an entry with -100 for cash and an entry with 100 for groceries' do
      cash = Account.new(name: 'Cash', category: 'Assets')
      groceries = Account.new(name: 'Groceries', category: 'Expenses')
      pay = create_transaction_type({
                                        type: PayExpense,
                                        book_date: Date.today,
                                        from_account: cash,
                                        to_account: groceries,
                                        amount: 100})

      pay.save

      assert_transaction({
                         transaction: pay.transaction,
                         from_account: cash, from_amount: -100,
                         to_account: groceries, to_amount: 100
                     })
    end

  end

  context 'given paying rent of value 550 by transferring money from Bank Account' do

    it 'when making the payment then it creates an entry with 550 for rent and an entry with -550 for bank account' do
      bank_account = Account.new(name: 'Bank', category: 'Assets')
      rent = Account.new(name: 'Rent', category: 'Expenses')
      pay = create_transaction_type({
                                        type: PayExpense,
                                        book_date: Date.today,
                                        from_account: bank_account,
                                        to_account: rent,
                                        amount: 550
                                    })

      pay.save

      assert_transaction({
                         transaction: pay.transaction,
                         from_account: bank_account, from_amount: -550,
                         to_account: rent, to_amount: 550
                     })
    end

  end

  context 'given paying mobile bill of value 40 with credit card' do

    it "when making the payment then it creates an entry of 40 for 'Accounts Payable' and entry of 40 for mobile" do
      accounts_payable = Account.new(name: 'Credit card', category: 'Liabilities')
      mobile = Account.new(name: 'Wind', category: 'Expenses')
      pay = create_transaction_type({
                                        type: PayExpense,
                                        book_date: Date.today,
                                        from_account: accounts_payable,
                                        to_account: mobile,
                                        amount: 40
                                    })

      pay.save

      assert_transaction({
                         transaction: pay.transaction,
                         from_account: accounts_payable, from_amount: 40,
                         to_account: mobile, to_amount: 40
                     })
    end

  end

  context 'Given an expense payment' do

    basic_validation('when it is initialized and checked for validation', PayExpense)

    context 'Given an expense payment with a to account of category not Expenses' do

      before do
        @salary = Account.new(name: 'Cash', category: 'Assets')
        @accounts_payable = Account.new(name: 'Bank', category: 'Liabilities')
        @pay = create_transaction_type({
                                           type: PayExpense,
                                           from_account: @salary,
                                           to_account: @accounts_payable,
                                           amount: 550
                                       })
      end

      it 'then it should not be valid because of the to account' do
        expect(@pay.valid?).to be_false
        expect(@pay.errors[:to].any?).to be_true
        expect(@pay.errors[:to]).to eq ['The to account category is not Expenses']
      end

      it 'then it should not save the payment because it is not valid' do
        expect { @pay.save }.to raise_error(RuntimeError, 'The expense payment is not valid')
      end

    end

    it "when having an expense payment with a from account of category not 'Assets' or a 'Liabilities' then it is invalid" do
      equity = Account.new(name: 'Equity', category: 'Equity')
      rent = Account.new(name: 'Rent', category: 'Expenses')
      pay = create_transaction_type({
                                        type: PayExpense,
                                        from_account: equity,
                                        to_account: rent,
                                        amount: 550
                                    })

      expect(pay.valid?).to be_false

      expect(pay.errors[:from].any?).to be_true
      expect(pay.errors[:from]).to eq ['The from account category is not Assets or Liabilities']
    end

  end

end
