class AddUsernameToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :user, :username, :string
    add_index :user, :username, unique: true
  end
end