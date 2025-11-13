class CreateItemEnvironments < ActiveRecord::Migration[8.1]
  def change
    create_table :item_environments, id: :uuid do |t|
      t.string :name, null: false
      t.string :description, null: true
      t.boolean :active, null: false, default: true

      t.timestamps
    end
    add_index :item_environments, :name, unique: true
  end
end
