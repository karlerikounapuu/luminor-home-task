class CreateConfigurationItems < ActiveRecord::Migration[8.1]
  def change
    create_table :configuration_items, id: :uuid do |t|
      t.string :name, null: false
      t.string :description, null: true
      t.belongs_to :item_type, type: :uuid, null: false, foreign_key: true
      t.belongs_to :item_status, type: :uuid, null: false, foreign_key: true
      t.belongs_to :item_environment, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
    add_index :configuration_items, :name, unique: true
  end
end
