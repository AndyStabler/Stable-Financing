class AddReferenceToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :reference, :string
  end
end
