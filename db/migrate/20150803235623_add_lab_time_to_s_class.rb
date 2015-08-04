class AddLabTimeToSClass < ActiveRecord::Migration
  def change
     add_column :s_classes,:lab_time ,:string
     add_column :s_classes,:lab_loc ,:string
     add_column :s_classes,:loc_prof ,:string
  end
end
