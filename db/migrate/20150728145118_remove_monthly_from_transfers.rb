class RemoveMonthlyFromTransfers < ActiveRecord::Migration
  def change
    remove_column :transfers, :monthly, :boolean
  end
end
