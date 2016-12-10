class CreateCnns < ActiveRecord::Migration[5.0]
  def change
    create_table :cnns do |t|
      t.string :author
      t.string :title
      t.text :description
      t.string :url
      t.string :image
      t.string :published
      t.timestamps
    end
  end
end
