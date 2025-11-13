class ConfigurationItemRelationship < ApplicationRecord
  belongs_to :source_configuration_item, class_name: "ConfigurationItem"
  belongs_to :target_configuration_item, class_name: "ConfigurationItem"
  belongs_to :relationship_type, optional: false

  # Validate uniqueness (belt and suspenders with DB constraint)
  validates :source_configuration_item_id, uniqueness: {
    scope: [ :target_configuration_item_id, :relationship_type_id ],
    message: "relationship already exists"
  }

  validate :prevent_self_reference
  validate :prevent_circular_dependency

  private

  def prevent_self_reference
    if source_configuration_item_id == target_configuration_item_id
      errors.add(:target_configuration_item, "cannot be the same as source")
    end
  end

  def prevent_circular_dependency
    return if source_configuration_item_id.nil? || target_configuration_item_id.nil?

    if creates_cycle?(target_configuration_item_id, source_configuration_item_id)
      errors.add(:target_configuration_item, "This would create a circular dependency")
    end
  end

  def creates_cycle?(source_id, target_id, visited = Set.new, depth = 0)
    return false if depth > 100
    return true if source_id == target_id
    return false if visited.include?(source_id)

    visited.add(source_id)

    ConfigurationItemRelationship
      .where(source_configuration_item_id: source_id)
      .where(relationship_type_id: relationship_type_id)
      .pluck(:target_configuration_item_id)
      .any? { |next_id| creates_cycle?(next_id, target_id, visited, depth + 1) }
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "relationship_type_id", "source_configuration_item_id", "target_configuration_item_id", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "relationship_type", "source_configuration_item", "target_configuration_item" ]
  end
end
