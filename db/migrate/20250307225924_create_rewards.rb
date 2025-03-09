class CreateRewards < ActiveRecord::Migration[8.0]
  def change
    create_table :rewards do |t|
      t.string :title
      t.string :subtitle
      t.integer :price

      t.timestamps
    end
    add_index :rewards, :title, unique: true
  end
end
