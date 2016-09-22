class CreateAwwwards < ActiveRecord::Migration[5.0]
  def change
    create_table :awwwards do |t|
      t.string :title
      t.string :url
      t.string :photo
      t.string :award
      t.timestamps
    end
  end
end
