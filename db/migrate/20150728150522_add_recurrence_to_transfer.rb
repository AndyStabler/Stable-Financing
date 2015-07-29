class AddRecurrenceToTransfer < ActiveRecord::Migration
  def change
    add_column :transfers, :recurrence, :integer, default: 1
  end
end
