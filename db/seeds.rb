# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

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
