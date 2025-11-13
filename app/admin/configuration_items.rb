ActiveAdmin.register ConfigurationItem do
  permit_params :name, :description, :item_type_id, :item_status_id, :item_environment_id

  index do
    selectable_column
    id_column
    column :name
    column :item_type
    column :item_status
    column :item_environment
    column :created_at
    actions
  end

  filter :name
  filter :item_type
  filter :item_status
  filter :item_environment
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :item_type, as: :select, collection: ItemType.where(active: true).order(:name)
      f.input :item_status, as: :select, collection: ItemStatus.where(active: true).order(:name)
      f.input :item_environment, as: :select, collection: ItemEnvironment.where(active: true).order(:name)
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :item_type
      row :item_status
      row :item_environment
      row :created_at
      row :updated_at
    end

    panel "Outgoing Relationships" do
      table_for configuration_item.outgoing_relationships do
        column "Type" do |rel|
          rel.relationship_type.name
        end
        column "Target" do |rel|
          link_to rel.target_configuration_item.name, admin_configuration_item_path(rel.target_configuration_item)
        end
        column "Actions" do |rel|
          link_to "View", admin_configuration_item_relationship_path(rel)
        end
      end
    end

    panel "Incoming Relationships" do
      table_for configuration_item.incoming_relationships do
        column "Type" do |rel|
          rel.relationship_type.name
        end
        column "Source" do |rel|
          link_to rel.source_configuration_item.name, admin_configuration_item_path(rel.source_configuration_item)
        end
        column "Actions" do |rel|
          link_to "View", admin_configuration_item_relationship_path(rel)
        end
      end
    end
  end
end
