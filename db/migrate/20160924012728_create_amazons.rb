class CreateAmazons < ActiveRecord::Migration[5.0]
  def change
    create_table :amazons do |t|
      t.string :title
      t.string :url
      t.decimal :price
      t.integer :discount
      t.timestamps
    end
  end
end
