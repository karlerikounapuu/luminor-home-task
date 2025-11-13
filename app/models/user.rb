class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable

  # Role-based authorization
  enum :role, { viewer: 0, admin: 1 }, default: :viewer

  def admin?
    role == "admin"
  end

  def viewer?
    role == "viewer"
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "email", "encrypted_password", "id", "id_value", "remember_created_at", "reset_password_sent_at", "reset_password_token", "role", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
