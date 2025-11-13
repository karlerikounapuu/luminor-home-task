require "test_helper"

class ConfigurationItemRelationshipsAdminIntegrationTest < ActionDispatch::IntegrationTest
  # Don't load fixtures for this test class
  self.use_instantiated_fixtures = false

  def setup
    @admin_user = User.create!(
      email: "admin@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: "admin"
    )

    @viewer_user = User.create!(
      email: "viewer@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: "viewer"
    )

    @item_type = ItemType.create!(name: "Server", active: true)
    @item_status = ItemStatus.create!(name: "Active", active: true)
    @item_environment = ItemEnvironment.create!(name: "Production", active: true)

    @ci1 = ConfigurationItem.create!(
      name: "Web Server",
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )

    @ci2 = ConfigurationItem.create!(
      name: "Database Server",
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )

    @ci3 = ConfigurationItem.create!(
      name: "Cache Server",
      item_type: @item_type,
      item_status: @item_status,
      item_environment: @item_environment
    )

    @relationship_type = RelationshipType.create!(name: "depends_on", active: true)
  end

  test "admin should be able to create relationship" do
    sign_in @admin_user

    assert_difference "ConfigurationItemRelationship.count", 1 do
      post admin_configuration_item_relationships_path, params: {
        configuration_item_relationship: {
          dependent_configuration_item_id: @ci1.id,
          dependency_configuration_item_id: @ci2.id,
          relationship_type_id: @relationship_type.id
        }
      }
    end
  end

  test "viewer should not be able to create relationship" do
    sign_in @viewer_user

    assert_no_difference "ConfigurationItemRelationship.count" do
      post admin_configuration_item_relationships_path, params: {
        configuration_item_relationship: {
          dependent_configuration_item_id: @ci1.id,
          dependency_configuration_item_id: @ci2.id,
          relationship_type_id: @relationship_type.id
        }
      }
    end

    assert_redirected_to admin_root_path
  end

  test "should prevent creating self-referencing relationship" do
    sign_in @admin_user

    assert_no_difference "ConfigurationItemRelationship.count" do
      post admin_configuration_item_relationships_path, params: {
        configuration_item_relationship: {
          dependent_configuration_item_id: @ci1.id,
          dependency_configuration_item_id: @ci1.id,
          relationship_type_id: @relationship_type.id
        }
      }
    end
  end

  test "should prevent creating circular dependency" do
    sign_in @admin_user

    ConfigurationItemRelationship.create!(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: @relationship_type
    )

    assert_no_difference "ConfigurationItemRelationship.count" do
      post admin_configuration_item_relationships_path, params: {
        configuration_item_relationship: {
          dependent_configuration_item_id: @ci2.id,
          dependency_configuration_item_id: @ci1.id,
          relationship_type_id: @relationship_type.id
        }
      }
    end
  end

  test "should prevent creating indirect circular dependency" do
    sign_in @admin_user

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

    assert_no_difference "ConfigurationItemRelationship.count" do
      post admin_configuration_item_relationships_path, params: {
        configuration_item_relationship: {
          dependent_configuration_item_id: @ci3.id,
          dependency_configuration_item_id: @ci1.id,
          relationship_type_id: @relationship_type.id
        }
      }
    end
  end

  test "admin should be able to delete relationship" do
    sign_in @admin_user

    relationship = ConfigurationItemRelationship.create!(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: @relationship_type
    )

    assert_difference "ConfigurationItemRelationship.count", -1 do
      delete admin_configuration_item_relationship_path(relationship)
    end

    assert_redirected_to admin_configuration_item_relationships_path
  end

  test "viewer should not be able to delete relationship" do
    sign_in @viewer_user

    relationship = ConfigurationItemRelationship.create!(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: @relationship_type
    )

    assert_no_difference "ConfigurationItemRelationship.count" do
      delete admin_configuration_item_relationship_path(relationship)
    end

    assert_redirected_to admin_root_path
  end

  test "should allow multiple relationship types between same CIs" do
    sign_in @admin_user

    relationship_type2 = RelationshipType.create!(name: "uses", active: true)

    # Create first relationship
    ConfigurationItemRelationship.create!(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: @relationship_type
    )

    # Create second relationship with different type
    assert_difference "ConfigurationItemRelationship.count", 1 do
      post admin_configuration_item_relationships_path, params: {
        configuration_item_relationship: {
          dependent_configuration_item_id: @ci1.id,
          dependency_configuration_item_id: @ci2.id,
          relationship_type_id: relationship_type2.id
        }
      }
    end
  end

  test "new relationship form should pre-populate dependent CI from params" do
    sign_in @admin_user

    get new_admin_configuration_item_relationship_path(dependent_configuration_item_id: @ci1.id)
    assert_response :success

    # Check that the form has the dependent CI pre-selected
    assert_match(/Web Server/, response.body)
  end

  private

  def sign_in(user)
    post user_session_path, params: {
      user: {
        email: user.email,
        password: "password123"
      }
    }
  end
end
