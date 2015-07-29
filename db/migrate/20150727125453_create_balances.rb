class CreateBalances < ActiveRecord::Migration
  def change
    create_table :balances do |t|
      t.decimal :value
      t.references :@transfer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
