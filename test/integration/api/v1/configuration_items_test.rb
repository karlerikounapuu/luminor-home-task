require "test_helper"

class ApiV1ConfigurationItemsIntegrationTest < ActionDispatch::IntegrationTest
  # Don't load fixtures for this test class
  self.use_instantiated_fixtures = false

  def setup
    @user = User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    @item_type = ItemType.create!(name: "Server", active: true)
    @item_status_active = ItemStatus.create!(name: "Active", active: true)
    @item_status_inactive = ItemStatus.create!(name: "Inactive", active: true)
    @item_environment = ItemEnvironment.create!(name: "Production", active: true)

    @ci1 = ConfigurationItem.create!(
      name: "Web Server",
      description: "Main web server",
      item_type: @item_type,
      item_status: @item_status_active,
      item_environment: @item_environment
    )

    @ci2 = ConfigurationItem.create!(
      name: "Database Server",
      description: "Main database",
      item_type: @item_type,
      item_status: @item_status_inactive,
      item_environment: @item_environment
    )

    @relationship_type = RelationshipType.create!(name: "depends_on", active: true)

    @relationship = ConfigurationItemRelationship.create!(
      dependent_configuration_item: @ci1,
      dependency_configuration_item: @ci2,
      relationship_type: @relationship_type
    )
  end

  test "should require authentication for index" do
    get api_v1_configuration_items_path
    assert_response :unauthorized
  end

  test "should require authentication for show" do
    get api_v1_configuration_item_path(@ci1)
    assert_response :unauthorized
  end

  test "should reject invalid credentials" do
    get api_v1_configuration_items_path,
        headers: { "Authorization" => basic_auth("wrong@example.com", "wrongpassword") }
    assert_response :unauthorized
  end

  test "should list all configuration items with valid auth" do
    get api_v1_configuration_items_path,
        headers: { "Authorization" => basic_auth(@user.email, "password123") }
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 2, json.length
    assert_equal [ "Database Server", "Web Server" ], json.map { |item| item["name"] }.sort
  end

  test "should filter by item_type" do
    get api_v1_configuration_items_path(item_type: "Server"),
        headers: { "Authorization" => basic_auth(@user.email, "password123") }
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 2, json.length
  end

  test "should filter by item_type case-insensitively" do
    get api_v1_configuration_items_path(item_type: "server"),
        headers: { "Authorization" => basic_auth(@user.email, "password123") }
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 2, json.length
  end

  test "should filter by item_status" do
    get api_v1_configuration_items_path(item_status: "Active"),
        headers: { "Authorization" => basic_auth(@user.email, "password123") }
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 1, json.length
    assert_equal "Web Server", json.first["name"]
  end

  test "should filter by item_status case-insensitively" do
    get api_v1_configuration_items_path(item_status: "active"),
        headers: { "Authorization" => basic_auth(@user.email, "password123") }
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal 1, json.length
    assert_equal "Web Server", json.first["name"]
  end

  test "should show configuration item details" do
    get api_v1_configuration_item_path(@ci1),
        headers: { "Authorization" => basic_auth(@user.email, "password123") }
    assert_response :success

    json = JSON.parse(response.body)
    assert_equal "Web Server", json["name"]
    assert_equal "Main web server", json["description"]
    assert_equal "Server", json["item_type"]
    assert_equal "Active", json["item_status"]
    assert_equal "Production", json["item_environment"]
  end

  test "should include dependencies in show response" do
    get api_v1_configuration_item_path(@ci1),
        headers: { "Authorization" => basic_auth(@user.email, "password123") }
    assert_response :success

    json = JSON.parse(response.body)
    assert json.key?("dependencies")
    assert_equal 1, json["dependencies"].length
    assert_equal "Database Server", json["dependencies"].first["configuration_item"]["name"]
    assert_equal "depends_on", json["dependencies"].first["relationship_type"]
  end

  test "should include dependents in show response" do
    get api_v1_configuration_item_path(@ci2),
        headers: { "Authorization" => basic_auth(@user.email, "password123") }
    assert_response :success

    json = JSON.parse(response.body)
    assert json.key?("dependents")
    assert_equal 1, json["dependents"].length
    assert_equal "Web Server", json["dependents"].first["configuration_item"]["name"]
    assert_equal "depends_on", json["dependents"].first["relationship_type"]
  end

  test "should return 404 for non-existent configuration item" do
    get api_v1_configuration_item_path(SecureRandom.uuid),
        headers: { "Authorization" => basic_auth(@user.email, "password123") }
    assert_response :not_found
  end

  test "index response should include required fields" do
    get api_v1_configuration_items_path,
        headers: { "Authorization" => basic_auth(@user.email, "password123") }
    assert_response :success

    json = JSON.parse(response.body)
    item = json.first

    assert item.key?("id")
    assert item.key?("name")
    assert item.key?("description")
    assert item.key?("item_type")
    assert item.key?("item_status")
    assert item.key?("item_environment")
  end

  private

  def basic_auth(email, password)
    ActionController::HttpAuthentication::Basic.encode_credentials(email, password)
  end
end
