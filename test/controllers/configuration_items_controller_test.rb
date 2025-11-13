require "test_helper"

class ConfigurationItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @configuration_item = configuration_items(:one)
  end

  test "should get index" do
    get configuration_items_url
    assert_response :success
  end

  test "should get new" do
    get new_configuration_item_url
    assert_response :success
  end

  test "should create configuration_item" do
    assert_difference("ConfigurationItem.count") do
      post configuration_items_url, params: { configuration_item: { description: @configuration_item.description, item_environment_id: @configuration_item.item_environment_id, item_status_id: @configuration_item.item_status_id, item_type_id: @configuration_item.item_type_id, name: "UniqueTestName" } }
    end

    assert_response :redirect
    assert_match %r{/configuration_items/[0-9a-f-]+}, @response.location
  end

  test "should show configuration_item" do
    get configuration_item_url(@configuration_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_configuration_item_url(@configuration_item)
    assert_response :success
  end

  test "should update configuration_item" do
    patch configuration_item_url(@configuration_item), params: { configuration_item: { description: @configuration_item.description, item_environment_id: @configuration_item.item_environment_id, item_status_id: @configuration_item.item_status_id, item_type_id: @configuration_item.item_type_id, name: @configuration_item.name } }
    assert_redirected_to configuration_item_url(@configuration_item)
  end

  test "should destroy configuration_item" do
    assert_difference("ConfigurationItem.count", -1) do
      delete configuration_item_url(@configuration_item)
    end

    assert_redirected_to configuration_items_url
  end
end
