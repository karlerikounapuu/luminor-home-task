class ItemType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :configuration_items, dependent: :restrict_with_error

  def self.ransackable_attributes(auth_object = nil)
    [ "active", "created_at", "description", "id", "name", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "configuration_items" ]
  end
end
