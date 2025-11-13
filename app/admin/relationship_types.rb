ActiveAdmin.register RelationshipType do
  menu parent: "Settings", priority: 4
  permit_params :name, :description, :active

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :active do |relationship_type|
      status_tag relationship_type.active ? 'Active' : 'Inactive', class: relationship_type.active ? 'ok' : 'error'
    end
    column :created_at
    actions
  end

  filter :name
  filter :active
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :active
    end
    f.actions
  end
end
