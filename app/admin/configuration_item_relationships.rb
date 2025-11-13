ActiveAdmin.register ConfigurationItemRelationship do
  permit_params :dependent_configuration_item_id, :dependency_configuration_item_id, :relationship_type_id

  controller do
    def new
      @configuration_item_relationship = ConfigurationItemRelationship.new
      authorize! :create, @configuration_item_relationship

      # Pre-populate from URL parameters
      if params[:dependent_configuration_item_id].present?
        @configuration_item_relationship.dependent_configuration_item_id = params[:dependent_configuration_item_id]
      end

      if params[:dependency_configuration_item_id].present?
        @configuration_item_relationship.dependency_configuration_item_id = params[:dependency_configuration_item_id]
      end

      new!
    end

    def create
      @configuration_item_relationship = ConfigurationItemRelationship.new(permitted_params[:configuration_item_relationship])
      authorize! :create, @configuration_item_relationship

      if @configuration_item_relationship.save
        redirect_to admin_configuration_item_path(@configuration_item_relationship.dependent_configuration_item),
                    notice: "Relationship was successfully created."
      else
        render :new
      end
    end
  end

  index do
    selectable_column
    id_column
    column :dependent_configuration_item
    column :relationship_type
    column :dependency_configuration_item
    column :created_at
    actions
  end

  filter :dependent_configuration_item
  filter :dependency_configuration_item
  filter :relationship_type
  filter :created_at

  form do |f|
    f.inputs do
      f.input :dependent_configuration_item, as: :select, collection: ConfigurationItem.order(:name)
      f.input :relationship_type, as: :select, collection: RelationshipType.where(active: true).order(:name)
      f.input :dependency_configuration_item, as: :select, collection: ConfigurationItem.order(:name)
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :dependent_configuration_item do |rel|
        link_to rel.dependent_configuration_item.name, admin_configuration_item_path(rel.dependent_configuration_item)
      end
      row :relationship_type
      row :dependency_configuration_item do |rel|
        link_to rel.dependency_configuration_item.name, admin_configuration_item_path(rel.dependency_configuration_item)
      end
      row :created_at
      row :updated_at
    end
  end
end
