class AddChoosedFieldsToCity < ActiveRecord::Migration[5.0]
  def change
    add_column :cities, :use_for_api, :string
  end
end
