class AddOnToBalance < ActiveRecord::Migration
  def change
    add_column :balances, :on, :datetime
  end
end
