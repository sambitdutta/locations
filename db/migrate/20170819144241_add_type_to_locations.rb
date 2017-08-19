class AddTypeToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :type, :string
    
    add_index :locations, [:id, :type]
  end
end
