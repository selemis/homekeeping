class CreateAccountingTransactions < ActiveRecord::Migration
  def change
    create_table :accounting_transactions do |t|
      t.date :book_date

      t.timestamps null: false
    end
  end
end
