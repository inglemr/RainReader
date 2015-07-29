class CreateSClasses < ActiveRecord::Migration
  def change
    create_table :s_classes do |t|
      t.string :CRN
      t.string :Course
      t.string :Title
      t.string :Campus
      t.string :Credits
      t.string :StartDate
      t.string :EndDate
      t.string :Days
      t.string :Time
      t.string :Location
      t.string :Instructor

      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :s_classes, [:user_id, :created_at]
  end
end
