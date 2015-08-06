class RemoveTransferFromBalances < ActiveRecord::Migration
  def change
    remove_column :balances, :transfer_id, :integer
  end
end
