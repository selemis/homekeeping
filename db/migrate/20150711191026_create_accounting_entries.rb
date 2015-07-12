class CreateAccountingEntries < ActiveRecord::Migration
  def change
    create_table :accounting_entries do |t|
      t.date :book_date
      t.decimal :amount

      t.timestamps null: false
    end
  end
end
