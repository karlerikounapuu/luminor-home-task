class AddCompositeIndexToConfigurationItems < ActiveRecord::Migration[8.1]
  def change
    add_index :configuration_items, [ :item_type_id, :item_status_id ],
              name: 'idx_configuration_items_on_type_and_status'
  end
end
