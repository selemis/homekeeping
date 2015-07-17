class RenameColumnToAccount < ActiveRecord::Migration
  def change
    rename_column :accounts, :type, :category
  end
end
