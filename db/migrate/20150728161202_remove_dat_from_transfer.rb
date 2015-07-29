class RemoveDatFromTransfer < ActiveRecord::Migration
  def change
    remove_column :transfers, :dat, :date
  end
end
