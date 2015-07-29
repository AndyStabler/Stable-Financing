class RenameTransactions < ActiveRecord::Migration
  def change
    rename_table :transactions, :transfer
  end
end
