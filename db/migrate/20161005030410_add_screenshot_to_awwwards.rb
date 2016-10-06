class AddScreenshotToAwwwards < ActiveRecord::Migration[5.0]
  def change
    add_column :awwwards, :screenshot, :string
  end
end
