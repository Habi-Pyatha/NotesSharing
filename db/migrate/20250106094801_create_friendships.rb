class CreateFriendships < ActiveRecord::Migration[7.2]
  def change
    create_table :friendships do |t|
      t.integer :user_id, null: false
      t.integer :friend_id, null: false
      t.string :status, default: "pending"

      t.timestamps
    end
    add_index :friendships, [ :user_id, :friend_id ], unique: true
    add_index :friendships, [ :friend_id, :user_id ], unique: true
  end
end
