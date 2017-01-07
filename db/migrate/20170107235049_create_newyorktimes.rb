class CreateNewyorktimes < ActiveRecord::Migration[5.0]
  def change
    create_table :newyorktimes do |t|
      t.string :title
      t.string :url
      t.string :image

      t.timestamps
    end
  end
end
