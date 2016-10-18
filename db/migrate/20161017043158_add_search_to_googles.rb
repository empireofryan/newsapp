class AddSearchToGoogles < ActiveRecord::Migration[5.0]
  def change
    add_column :googles, :search, :string
  end
end
