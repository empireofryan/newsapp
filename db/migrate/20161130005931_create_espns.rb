class CreateEspns < ActiveRecord::Migration[5.0]
  def change
    create_table :espns do |t|
      t.string :title
      t.text :description
      t.string :image
      t.string :url
      t.string :published

      t.timestamps
    end
  end
end
