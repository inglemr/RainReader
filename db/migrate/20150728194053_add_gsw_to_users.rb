class AddGswToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gswid, :string
    add_column :users, :gswpin, :string
  end
end
