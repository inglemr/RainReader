class ChangeBooleanFormatInSClass < ActiveRecord::Migration
    def up
    change_column :s_classes,:open, :string
  end

  def down
    change_column :s_classes,:open, :boolean
  end
end
