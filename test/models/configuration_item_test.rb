require "test_helper"

class ConfigurationItemTest < ActiveSupport::TestCase
  # Don't load fixtures for this test class
  self.use_instantiated_fixtures = false

  def setup
    @item_type = ItemType.create!(name: "Server", description: "Server type", active: true)
    @item_status = ItemStatus.create!(name: "Active", description: "Active status", active: true)
    @item_environment = ItemEnvironment.create!(name: "Production", description: "Prod env", active: true)
  end

  test "should create valid configuration item" do
    ci = ConfigurationItem.new(
      name: "Web Server",
      description: "Main web server",
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )
    assert ci.valid?
    assert ci.save
  end

  test "should require name" do
    ci = ConfigurationItem.new(
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )
    assert_not ci.valid?
    assert_includes ci.errors[:name], "can't be blank"
  end

  test "should enforce unique name case-insensitively" do
    ConfigurationItem.create!(
      name: "Web Server",
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )

    ci = ConfigurationItem.new(
      name: "web server",
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )
    assert_not ci.valid?
    assert_includes ci.errors[:name], "has already been taken"
  end

  test "should allow deletion of CI without dependents" do
    ci = ConfigurationItem.create!(
      name: "Web Server",
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )

    assert_difference "ConfigurationItem.count", -1 do
      ci.destroy
    end
  end

  test "should prevent deletion of CI with dependents" do
    db = ConfigurationItem.create!(
      name: "Database",
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )

    web = ConfigurationItem.create!(
      name: "Web Server",
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )

    relationship_type = RelationshipType.create!(name: "depends_on", active: true)

    ConfigurationItemRelationship.create!(
      dependent_configuration_item: web,
      dependency_configuration_item: db,
      relationship_type: relationship_type
    )

    assert_no_difference "ConfigurationItem.count" do
      db.destroy
    end

    assert_includes db.errors[:base], "Cannot delete this Configuration Item because it has dependents: Web Server"
  end

  test "should delete outgoing relationships when CI is deleted" do
    ci1 = ConfigurationItem.create!(
      name: "CI 1",
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )

    ci2 = ConfigurationItem.create!(
      name: "CI 2",
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )

    relationship_type = RelationshipType.create!(name: "depends_on", active: true)

    ConfigurationItemRelationship.create!(
      dependent_configuration_item: ci1,
      dependency_configuration_item: ci2,
      relationship_type: relationship_type
    )

    assert_difference "ConfigurationItemRelationship.count", -1 do
      ci1.destroy
    end
  end
end
