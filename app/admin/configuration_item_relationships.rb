ActiveAdmin.register ConfigurationItemRelationship do
  permit_params :source_configuration_item_id, :target_configuration_item_id, :relationship_type_id

  index do
    selectable_column
    id_column
    column :source_configuration_item
    column :relationship_type
    column :target_configuration_item
    column :created_at
    actions
  end

  filter :source_configuration_item
  filter :target_configuration_item
  filter :relationship_type
  filter :created_at

  form do |f|
    f.inputs do
      f.input :source_configuration_item, as: :select, collection: ConfigurationItem.order(:name)
      f.input :relationship_type, as: :select, collection: RelationshipType.where(active: true).order(:name)
      f.input :target_configuration_item, as: :select, collection: ConfigurationItem.order(:name)
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :source_configuration_item do |rel|
        link_to rel.source_configuration_item.name, admin_configuration_item_path(rel.source_configuration_item)
      end
      row :relationship_type
      row :target_configuration_item do |rel|
        link_to rel.target_configuration_item.name, admin_configuration_item_path(rel.target_configuration_item)
      end
      row :created_at
      row :updated_at
    end
  end
end
