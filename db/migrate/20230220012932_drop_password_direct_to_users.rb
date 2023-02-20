class DropPasswordDirectToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :password_direct
  end
end
