class ConfigurationItemRelationship < ApplicationRecord
  belongs_to :dependent_configuration_item, class_name: "ConfigurationItem"
  belongs_to :dependency_configuration_item, class_name: "ConfigurationItem"
  belongs_to :relationship_type, optional: false

  # Validate uniqueness (belt and suspenders with DB constraint)
  validates :dependent_configuration_item_id, uniqueness: {
    scope: [ :dependency_configuration_item_id, :relationship_type_id ],
    message: "relationship already exists"
  }

  validate :prevent_self_reference
  validate :prevent_circular_dependency

  private

  def prevent_self_reference
    if dependent_configuration_item_id == dependency_configuration_item_id
      errors.add(:dependency_configuration_item, "cannot be the same as dependent")
    end
  end

  def prevent_circular_dependency
    return if dependent_configuration_item_id.nil? || dependency_configuration_item_id.nil?

    # Check if adding this relationship would create a cycle
    # We check across ALL relationship types since depends_on, uses, runs_on are all dependencies
    if would_create_cycle?
      errors.add(:dependency_configuration_item, "This relationship would create a circular dependency")
    end
  end

  def would_create_cycle?
    # If we can reach the dependent from the dependency (following ANY relationship type),
    # then adding dependent -> dependency would create a cycle
    can_reach?(dependency_configuration_item_id, dependent_configuration_item_id)
  end

  def can_reach? (from_id, to_id, visited = Set.new, depth = 0)
    return false if depth > 100 # Prevent infinite loops
    return true if from_id == to_id
    return false if visited.include?(from_id)

    visited.add(from_id)

    # Find all items that 'from_id' points to with ANY relationship type
    ConfigurationItemRelationship
      .where(dependent_configuration_item_id: from_id)
      .where.not(id: id) # Exclude current record if it's an update
      .pluck(:dependency_configuration_item_id)
      .any? { |next_id| can_reach?(next_id, to_id, visited, depth + 1) }
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "relationship_type_id", "dependent_configuration_item_id", "dependency_configuration_item_id", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "relationship_type", "dependent_configuration_item", "dependency_configuration_item" ]
  end
end
