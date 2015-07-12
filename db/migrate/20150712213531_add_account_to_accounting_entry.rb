class AddAccountToAccountingEntry < ActiveRecord::Migration
  def change
    add_reference :accounting_entries, :account, index: true
    add_foreign_key :accounting_entries, :account
  end
end
