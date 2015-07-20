class AddTransactionToAccountingEntries < ActiveRecord::Migration
  def change
    add_reference :accounting_entries, :accounting_transaction, index: true
    add_foreign_key :accounting_entries, :accounting_transaction
  end
end
