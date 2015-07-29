class RemoveWeeklyFromTransfers < ActiveRecord::Migration
  def change
    remove_column :transfers, :weekly, :boolean
  end
end
