ActiveAdmin.register ItemType do
  menu parent: "Settings", priority: 1
  permit_params :name, :description, :active

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :active do |item_type|
      status_tag item_type.active ? 'Active' : 'Inactive', class: item_type.active ? 'ok' : 'error'
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
