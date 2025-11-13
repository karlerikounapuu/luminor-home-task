class ConfigurationItem < ApplicationRecord
  belongs_to :item_type
  belongs_to :item_status
  belongs_to :item_environment

  validates :name, presence: true, uniqueness: true

  # Add relationship associations
  # Dependencies: what this CI depends on
  has_many :outgoing_relationships,
           class_name: "ConfigurationItemRelationship",
           foreign_key: :dependent_configuration_item_id,
           dependent: :destroy

  # Dependents: what depends on this CI
  has_many :incoming_relationships,
           class_name: "ConfigurationItemRelationship",
           foreign_key: :dependency_configuration_item_id,
           dependent: :restrict_with_error

  # Convenience methods
  has_many :dependencies, through: :outgoing_relationships, source: :dependency_configuration_item
  has_many :dependents, through: :incoming_relationships, source: :dependent_configuration_item

  # Prevent deletion if this CI has dependents
  before_destroy :check_for_dependents

  private

  def check_for_dependents
    if incoming_relationships.any?
      dependent_names = dependents.pluck(:name).join(", ")
      errors.add(:base, "Cannot delete this Configuration Item because it has dependents: #{dependent_names}")
      throw(:abort)
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "description", "id", "item_environment_id", "item_status_id", "item_type_id", "name", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "dependencies", "dependents", "incoming_relationships", "item_environment", "item_status", "item_type", "outgoing_relationships" ]
  end
end
