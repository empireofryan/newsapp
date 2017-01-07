class CreateTableNewYorkTimes < ActiveRecord::Migration[5.0]
  def change
    create_table :table_new_york_times do |t|
      t.string :title
      t.string :url
      t.string :image
    end
  end
end
