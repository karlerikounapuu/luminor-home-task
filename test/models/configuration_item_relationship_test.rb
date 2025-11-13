require "test_helper"

class ConfigurationItemRelationshipTest < ActiveSupport::TestCase
  # Don't load fixtures for this test class
  self.use_instantiated_fixtures = false

  def setup
    @item_type = ItemType.create!(name: "Server", active: true)
    @item_status = ItemStatus.create!(name: "Active", active: true)
    @item_environment = ItemEnvironment.create!(name: "Production", active: true)
    @relationship_type = RelationshipType.create!(name: "depends_on", active: true)

    @ci1 = ConfigurationItem.create!(
      name: "CI 1",
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )

    @ci2 = ConfigurationItem.create!(
      name: "CI 2",
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )

    @ci3 = ConfigurationItem.create!(
      name: "CI 3",
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )
  end

  test "should create valid relationship" do
    rel = ConfigurationItemRelationship.new(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: @relationship_type
    )
    assert rel.valid?
    assert rel.save
  end

  test "should prevent self-reference" do
    rel = ConfigurationItemRelationship.new(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci1,
      relationship_type: @relationship_type
    )
    assert_not rel.valid?
    assert_includes rel.errors[:dependency_configuration_item], "cannot be the same as dependent"
  end

  test "should prevent duplicate relationships" do
    ConfigurationItemRelationship.create!(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: @relationship_type
    )

    rel = ConfigurationItemRelationship.new(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: @relationship_type
    )
    assert_not rel.valid?
    assert_includes rel.errors[:dependent_configuration_item_id], "relationship already exists"
  end

  test "should prevent circular dependencies" do
    # Create CI1 -> CI2
    ConfigurationItemRelationship.create!(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: @relationship_type
    )

    # Try to create CI2 -> CI1 (would create cycle)
    rel = ConfigurationItemRelationship.new(
      dependent_configuration_item: @ci2,
      dependency_configuration_item: @ci1,
      relationship_type: @relationship_type
    )
    assert_not rel.valid?
    assert_includes rel.errors[:dependency_configuration_item], "This relationship would create a circular dependency"
  end

  test "should prevent indirect circular dependencies" do
    ConfigurationItemRelationship.create!(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: @relationship_type
    )

    ConfigurationItemRelationship.create!(
      dependent_configuration_item: @ci2,
      dependency_configuration_item: @ci3,
      relationship_type: @relationship_type
    )

    rel = ConfigurationItemRelationship.new(
      dependent_configuration_item: @ci3,
      dependency_configuration_item: @ci1,
      relationship_type: @relationship_type
    )
    assert_not rel.valid?
    assert_includes rel.errors[:dependency_configuration_item], "This relationship would create a circular dependency"
  end

  test "should allow multiple relationship types between same CIs" do
    relationship_type2 = RelationshipType.create!(name: "uses", active: true)

    ConfigurationItemRelationship.create!(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: @relationship_type
    )

    rel = ConfigurationItemRelationship.new(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: relationship_type2
    )
    assert rel.valid?
    assert rel.save
  end

  test "circular dependency check should work across all relationship types" do
    relationship_type2 = RelationshipType.create!(name: "uses", active: true)

    ConfigurationItemRelationship.create!(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: @relationship_type
    )

    rel = ConfigurationItemRelationship.new(
      dependent_configuration_item: @ci2,
      dependency_configuration_item: @ci1,
      relationship_type: relationship_type2
    )
    assert_not rel.valid?
    assert_includes rel.errors[:dependency_configuration_item], "This relationship would create a circular dependency"
  end
end
