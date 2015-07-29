class FixBalanceTransferId < ActiveRecord::Migration
  def change
    rename_column :balances, :transaction_id, :transfer_id
  end
end
