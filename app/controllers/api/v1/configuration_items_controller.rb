module Api
  module V1
    class ConfigurationItemsController < BaseController
      def index
        items = ConfigurationItem.includes(:item_type, :item_status, :item_environment)

        # Filter by item type (case-insensitive)
        if params[:item_type].present?
          item_type = ItemType.where("LOWER(name) = ?", params[:item_type].downcase).first
          items = items.where(item_type: item_type) if item_type
        end

        # Filter by item status (case-insensitive)
        if params[:item_status].present?
          item_status = ItemStatus.where("LOWER(name) = ?", params[:item_status].downcase).first
          items = items.where(item_status: item_status) if item_status
        end

        render json: items.order(:name).map { |item| configuration_item_json(item) }
      end

      def show
        item = ConfigurationItem.includes(
          :item_type,
          :item_status,
          :item_environment,
          outgoing_relationships: [ :relationship_type, :dependency_configuration_item ],
          incoming_relationships: [ :relationship_type, :dependent_configuration_item ]
        ).find(params[:id])

        render json: configuration_item_detail_json(item)
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Configuration Item not found" }, status: :not_found
      end

      private

      def configuration_item_json(item)
        {
          id: item.id,
          name: item.name,
          description: item.description,
          item_type: item.item_type.name,
          item_status: item.item_status.name,
          item_environment: item.item_environment.name,
          created_at: item.created_at,
          updated_at: item.updated_at
        }
      end

      def configuration_item_detail_json(item)
        configuration_item_json(item).merge(
          dependencies: item.outgoing_relationships.map do |rel|
            {
              id: rel.id,
              relationship_type: rel.relationship_type.name,
              configuration_item: {
                id: rel.dependency_configuration_item.id,
                name: rel.dependency_configuration_item.name
              }
            }
          end,
          dependents: item.incoming_relationships.map do |rel|
            {
              id: rel.id,
              relationship_type: rel.relationship_type.name,
              configuration_item: {
                id: rel.dependent_configuration_item.id,
                name: rel.dependent_configuration_item.name
              }
            }
          end
        )
      end
    end
  end
end
