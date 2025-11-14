# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create admin and viewer users
User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = :admin
end

User.find_or_create_by!(email: 'viewer@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.role = :viewer
end

ItemStatus.find_or_create_by!(name: 'Active') do |status|
  status.active = true
  status.description = 'Active and in use'
end

ItemStatus.find_or_create_by!(name: 'Retired') do |status|
  status.active = true
  status.description = 'Retired and is no longer in use'
end

ItemStatus.find_or_create_by!(name: 'Maintenance') do |status|
  status.active = true
  status.description = 'Under maintenance'
end

ItemType.find_or_create_by!(name: 'Server') do |type|
  type.active = true
  type.description = 'Physical or virtual server hardware'
end

ItemType.find_or_create_by!(name: 'Application') do |type|
  type.active = true
  type.description = 'Software application or service'
end

ItemType.find_or_create_by!(name: 'Database') do |type|
  type.active = true
  type.description = 'Database system or instance'
end

ItemEnvironment.find_or_create_by!(name: 'Production') do |env|
  env.active = true
  env.description = 'Production environment for live systems'
end

ItemEnvironment.find_or_create_by!(name: 'Staging') do |env|
  env.active = true
  env.description = 'Staging environment for pre-production testing'
end

ItemEnvironment.find_or_create_by!(name: 'Development') do |env|
  env.active = true
  env.description = 'Development environment for testing and development'
end

RelationshipType.find_or_create_by!(name: 'depends_on') do |type|
  type.active = true
  type.description = 'This item depends on another item to function'
end

RelationshipType.find_or_create_by!(name: 'runs_on') do |type|
  type.active = true
  type.description = 'This item runs on another item (e.g., application runs on server)'
end

RelationshipType.find_or_create_by!(name: 'uses') do |type|
  type.active = true
  type.description = 'This item uses another item as a resource'
end

RelationshipType.find_or_create_by!(name: 'connects_to') do |type|
  type.active = true
  type.description = 'This item connects to another item'
end

active_status = ItemStatus.find_by(name: 'Active')
server_type = ItemType.find_by(name: 'Server')
application_type = ItemType.find_by(name: 'Application')
database_type = ItemType.find_by(name: 'Database')
production_env = ItemEnvironment.find_by(name: 'Production')

raspberry_pi = ConfigurationItem.find_or_create_by!(name: 'Raspberry Pi') do |item|
  item.description = 'Raspberry Pi server hosting applications'
  item.item_type = server_type
  item.item_status = active_status
  item.item_environment = production_env
end

postgres_db = ConfigurationItem.find_or_create_by!(name: 'PostgreSQL Database') do |item|
  item.description = 'Main PostgreSQL database instance'
  item.item_type = database_type
  item.item_status = active_status
  item.item_environment = production_env
end

backend_app = ConfigurationItem.find_or_create_by!(name: 'Backend API') do |item|
  item.description = 'Backend REST API application'
  item.item_type = application_type
  item.item_status = active_status
  item.item_environment = production_env
end

frontend_app = ConfigurationItem.find_or_create_by!(name: 'Frontend Application') do |item|
  item.description = 'React frontend application'
  item.item_type = application_type
  item.item_status = active_status
  item.item_environment = production_env
end

runs_on_type = RelationshipType.find_by(name: 'runs_on')
depends_on_type = RelationshipType.find_by(name: 'depends_on')
uses_type = RelationshipType.find_by(name: 'uses')

ConfigurationItemRelationship.find_or_create_by!(
  dependent_configuration_item: postgres_db,
  dependency_configuration_item: raspberry_pi,
  relationship_type: runs_on_type
)

ConfigurationItemRelationship.find_or_create_by!(
  dependent_configuration_item: backend_app,
  dependency_configuration_item: raspberry_pi,
  relationship_type: runs_on_type
)

ConfigurationItemRelationship.find_or_create_by!(
  dependent_configuration_item: backend_app,
  dependency_configuration_item: postgres_db,
  relationship_type: uses_type
)

ConfigurationItemRelationship.find_or_create_by!(
  dependent_configuration_item: frontend_app,
  dependency_configuration_item: backend_app,
  relationship_type: depends_on_type
)
