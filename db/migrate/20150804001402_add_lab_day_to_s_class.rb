class AddLabDayToSClass < ActiveRecord::Migration
  def change
     add_column :s_classes,:lab_day ,:string
  end
end
