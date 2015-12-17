class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.integer :friend_id
      t.integer :user_id
      t.text :request_status, null: false, default: "pending"
      t.timestamps null: false
   end
  end
end
