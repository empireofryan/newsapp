class CreateImgurs < ActiveRecord::Migration[5.0]
  def change
    create_table :imgurs do |t|
      t.string :url
      t.string :image
      t.timestamps
    end
  end
end
