class RenameTransferToTransfers < ActiveRecord::Migration
  def change
    rename_table :transfer, :transfers
  end
end
