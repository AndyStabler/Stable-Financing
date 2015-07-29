class RemoveDailyFromTransfers < ActiveRecord::Migration
  def change
    remove_column :transfers, :daily, :boolean
  end
end
