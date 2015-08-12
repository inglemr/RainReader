class CreateSClassUsersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :s_classes_users, :id => false do |t|
      t.integer :user_id
      t.integer :s_class_id
    end

    add_index :s_classes_users, [:user_id, :s_class_id]
  end

  def self.down
    drop_table :s_classes_users
  end
end
