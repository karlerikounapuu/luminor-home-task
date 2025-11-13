require "test_helper"

class ConfigurationItemsAdminIntegrationTest < ActionDispatch::IntegrationTest
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
  end

  test "admin should be able to access configuration items index" do
    sign_in @admin_user
    get admin_configuration_items_path
    assert_response :success
  end

  test "viewer should be able to access configuration items index" do
    sign_in @viewer_user
    get admin_configuration_items_path
    assert_response :success
  end

  test "unauthenticated user should be redirected to login" do
    get admin_configuration_items_path
    assert_redirected_to new_user_session_path
  end

  test "admin should be able to create configuration item" do
    sign_in @admin_user

    assert_difference "ConfigurationItem.count", 1 do
      post admin_configuration_items_path, params: {
        configuration_item: {
          name: "New Server",
          description: "Test server",
          item_type_id: @item_type.id,
          item_status_id: @item_status.id,
          item_environment_id: @item_environment.id
        }
      }
    end

    # Find the newly created item by the unique name
    new_item = ConfigurationItem.find_by(name: "New Server")
    assert_redirected_to admin_configuration_item_path(new_item)
  end

  test "viewer should not be able to create configuration item" do
    sign_in @viewer_user

    assert_no_difference "ConfigurationItem.count" do
      post admin_configuration_items_path, params: {
        configuration_item: {
          name: "New Server",
          item_type_id: @item_type.id,
          item_status_id: @item_status.id,
          item_environment_id: @item_environment.id
        }
      }
    end

    assert_redirected_to admin_root_path
  end

  test "admin should be able to update configuration item" do
    sign_in @admin_user

    patch admin_configuration_item_path(@ci1), params: {
      configuration_item: {
        name: "Updated Web Server"
      }
    }

    @ci1.reload
    assert_equal "Updated Web Server", @ci1.name
    assert_redirected_to admin_configuration_item_path(@ci1)
  end

  test "viewer should not be able to update configuration item" do
    sign_in @viewer_user

    patch admin_configuration_item_path(@ci1), params: {
      configuration_item: {
        name: "Updated Web Server"
      }
    }

    @ci1.reload
    assert_equal "Web Server", @ci1.name
    assert_redirected_to admin_root_path
  end

  test "admin should be able to delete configuration item without dependents" do
    sign_in @admin_user

    assert_difference "ConfigurationItem.count", -1 do
      delete admin_configuration_item_path(@ci1)
    end

    assert_redirected_to admin_configuration_items_path
  end

  test "viewer should not be able to delete configuration item" do
    sign_in @viewer_user

    assert_no_difference "ConfigurationItem.count" do
      delete admin_configuration_item_path(@ci1)
    end

    assert_redirected_to admin_root_path
  end

  test "admin should not be able to delete configuration item with dependents" do
    sign_in @admin_user

    relationship_type = RelationshipType.create!(name: "depends_on", active: true)
    ConfigurationItemRelationship.create!(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: relationship_type
    )

    assert_no_difference "ConfigurationItem.count" do
      delete admin_configuration_item_path(@ci2)
    end
  end

  test "should display configuration item details with relationships" do
    sign_in @admin_user

    relationship_type = RelationshipType.create!(name: "depends_on", active: true)
    ConfigurationItemRelationship.create!(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: relationship_type
    )

    get admin_configuration_item_path(@ci1)
    assert_response :success

    # Check for Dependencies panel
    assert_match(/Dependencies/, response.body)
    assert_match(/Database Server/, response.body)

    # Check for Dependents panel on the dependency
    get admin_configuration_item_path(@ci2)
    assert_response :success
    assert_match(/Dependents/, response.body)
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
