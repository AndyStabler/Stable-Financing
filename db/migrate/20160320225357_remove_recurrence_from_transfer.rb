class RemoveRecurrenceFromTransfer < ActiveRecord::Migration
  def change
    remove_column :transfers, :recurrence, :integer
  end
end
