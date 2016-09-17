class AddFieldsToCity < ActiveRecord::Migration[5.0]
  def change
    add_column :cities, :zip_code, :string
    add_column :cities, :lat, :float
    add_column :cities, :lng, :float
    add_column :cities, :city_id, :integer
  end
end
