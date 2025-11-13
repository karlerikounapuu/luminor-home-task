class RelationshipType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :configuration_item_relationships, dependent: :restrict_with_error
end
