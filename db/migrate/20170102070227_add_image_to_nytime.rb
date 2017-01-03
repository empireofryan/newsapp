class AddImageToNytime < ActiveRecord::Migration[5.0]
  def change
    add_column :nytimes, :image, :string
  end
end
