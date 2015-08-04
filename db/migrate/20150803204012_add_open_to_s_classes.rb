class AddOpenToSClasses < ActiveRecord::Migration
  def change
     add_column :s_classes,:open, :boolean
     add_column :s_classes,:open_seats ,:string
     add_column :s_classes,:tot_seats ,:string
     add_column :s_classes,:term ,:string
     add_column :s_classes,:course_num ,:string
     add_column :s_classes,:course_code ,:string
  end
end
