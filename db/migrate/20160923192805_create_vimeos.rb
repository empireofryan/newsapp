class CreateVimeos < ActiveRecord::Migration[5.0]
  def change
    create_table :vimeos do |t|
      t.string :title
      t.string :url
      t.string :picture
      t.timestamps
    end
  end
end
