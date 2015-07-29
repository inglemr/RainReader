class AddClassUpdatedTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :classUpdateTime, :datetime
  end
end
