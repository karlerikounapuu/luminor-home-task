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

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "description", "id", "item_environment_id", "item_status_id", "item_type_id", "name", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "incoming_relationships", "item_environment", "item_status", "item_type", "outgoing_relationships", "sources", "targets" ]
  end
end
