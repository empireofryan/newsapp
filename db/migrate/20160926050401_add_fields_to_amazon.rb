class AddFieldsToAmazon < ActiveRecord::Migration[5.0]
  def change
    add_column :amazons, :price_a, :string
    add_column :amazons, :discount_a, :string
  end
end
