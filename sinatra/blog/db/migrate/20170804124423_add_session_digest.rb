class AddSessionDigest < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :remember_digest, :string
    add_column :users, :salt, :string
  end
end