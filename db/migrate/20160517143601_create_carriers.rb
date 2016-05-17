class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :code, limit: 7
      t.string :description

      t.timestamps null: false
    end
    add_index :carriers, :code, unique: true
  end
end
