class ChangeFieldsInLocations < ActiveRecord::Migration
  def up
    change_column :locations, :latitude, :decimal, precision: 63, scale: 10
    change_column :locations, :longitude, :decimal, precision: 63, scale: 10
  end
  
  def down
    change_column :locations, :latitude, :float
    change_column :locations, :longitude, :float
  end
end
