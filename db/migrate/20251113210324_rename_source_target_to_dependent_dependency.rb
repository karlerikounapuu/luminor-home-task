class RenameSourceTargetToDependentDependency < ActiveRecord::Migration[8.1]
  def change
    # Rename columns
    rename_column :configuration_item_relationships, :source_configuration_item_id, :dependent_configuration_item_id
    rename_column :configuration_item_relationships, :target_configuration_item_id, :dependency_configuration_item_id

    # Remove old index
    remove_index :configuration_item_relationships,
                 name: "unique_configuration_item_relationship"

    # Add new index with updated column names
    add_index :configuration_item_relationships,
              [ :dependent_configuration_item_id, :dependency_configuration_item_id, :relationship_type_id ],
              unique: true,
              name: "unique_configuration_item_relationship"

    # Remove old check constraint
    remove_check_constraint :configuration_item_relationships,
                            name: "no_ci_relationship_self_reference"

    # Add new check constraint with updated column names
    add_check_constraint :configuration_item_relationships,
                         "dependent_configuration_item_id != dependency_configuration_item_id",
                         name: "no_ci_relationship_self_reference"
  end
end
