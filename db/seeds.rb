# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

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

if Rails.env.development?
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
end
