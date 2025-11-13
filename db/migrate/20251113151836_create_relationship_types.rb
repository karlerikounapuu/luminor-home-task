class CreateRelationshipTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :relationship_types, id: :uuid do |t|
      t.string :name
      t.string :description
      t.boolean :active

      t.timestamps
    end
    add_index :relationship_types, :name, unique: true
  end
end
