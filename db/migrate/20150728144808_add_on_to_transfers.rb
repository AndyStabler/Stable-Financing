class AddOnToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :on, :datetime
  end
end
