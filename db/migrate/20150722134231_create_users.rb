class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.decimal :balance, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
