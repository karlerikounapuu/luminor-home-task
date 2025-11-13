class CreateConfigurationItemRelationships < ActiveRecord::Migration[8.1]
  def change
    create_table :configuration_item_relationships, id: :uuid do |t|
      t.references :source_configuration_item, type: :uuid, null: false,
                   foreign_key: { to_table: :configuration_items }
      t.references :target_configuration_item, type: :uuid, null: false,
                   foreign_key: { to_table: :configuration_items }
      t.references :relationship_type, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end

    add_index :configuration_item_relationships,
              [ :source_configuration_item_id, :target_configuration_item_id, :relationship_type_id ],
              unique: true,
              name: 'unique_configuration_item_relationship'

    add_check_constraint :configuration_item_relationships,
                         "source_configuration_item_id != target_configuration_item_id",
                         name: "no_ci_relationship_self_reference"
  end
end
