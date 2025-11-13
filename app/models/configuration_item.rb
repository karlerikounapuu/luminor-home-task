class ConfigurationItem < ApplicationRecord
  belongs_to :item_type
  belongs_to :item_status
  belongs_to :item_environment

  validates :name, presence: true, uniqueness: true

  # Add relationship associations
  has_many :outgoing_relationships,
           class_name: "ConfigurationItemRelationship",
           foreign_key: :source_configuration_item_id,
           dependent: :destroy

  has_many :incoming_relationships,
           class_name: "ConfigurationItemRelationship",
           foreign_key: :target_configuration_item_id,
           dependent: :destroy

  # Convenience methods
  has_many :targets, through: :outgoing_relationships, source: :target_configuration_item
  has_many :sources, through: :incoming_relationships, source: :source_configuration_item
end
