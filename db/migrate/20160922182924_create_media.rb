class CreateMediums < ActiveRecord::Migration[5.0]
  def change
    create_table :mediums do |t|
      t.string :title
      t.string :url
      t.timestamps
    end
  end
end