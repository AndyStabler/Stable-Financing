class RemoveRememberDigestFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :remember_digest, :string
  end
end
