class ChangeAmazonTypes < ActiveRecord::Migration[5.0]
  def change
    change_column :amazons, :price, :string
    change_column :amazons, :discount, :string
  end
end
