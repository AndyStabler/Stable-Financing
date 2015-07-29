class AddOutgoingToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :outgoing, :boolean
  end
end
