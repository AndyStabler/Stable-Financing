class AddTypeToTransfer < ActiveRecord::Migration
  def change
    add_column :transfers, :type, :string
  end
end
