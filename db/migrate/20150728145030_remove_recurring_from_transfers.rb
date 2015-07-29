class RemoveRecurringFromTransfers < ActiveRecord::Migration
  def change
    remove_column :transfers, :recurring, :boolean
  end
end
