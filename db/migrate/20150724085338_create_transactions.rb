class CreateTransactions < ActiveRecord::Migration
  def change
    drop_table :transactions
    create_table :transactions do |t|
      t.date :dat
      t.decimal :amount
      t.boolean :recurring
      t.boolean :daily
      t.boolean :weekly
      t.boolean :monthly

      t.timestamps null: false
    end
  end
end
