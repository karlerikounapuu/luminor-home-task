json.extract! configuration_item, :id, :name, :description, :item_type_id, :item_status_id, :item_environment_id, :created_at, :updated_at
json.url configuration_item_url(configuration_item, format: :json)
