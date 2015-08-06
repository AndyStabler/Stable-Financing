class AddUserRefToBalances < ActiveRecord::Migration
  def change
    add_reference :balances, :user, index: true, foreign_key: true
  end
end
