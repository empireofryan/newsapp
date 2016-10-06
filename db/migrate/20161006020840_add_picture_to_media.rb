class AddPictureToMedia < ActiveRecord::Migration[5.0]
  def change
    add_column :media, :picture, :string
  end
end
