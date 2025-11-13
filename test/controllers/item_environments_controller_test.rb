require "test_helper"

class ItemEnvironmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item_environment = item_environments(:one)
  end

  test "should get index" do
    get item_environments_url
    assert_response :success
  end

  test "should get new" do
    get new_item_environment_url
    assert_response :success
  end

  test "should create item_environment" do
    assert_difference("ItemEnvironment.count") do
      post item_environments_url, params: { item_environment: { active: @item_environment.active, description: @item_environment.description, name: "development" } }
    end

    assert_redirected_to item_environment_url(ItemEnvironment.last)
  end

  test "should show item_environment" do
    get item_environment_url(@item_environment)
    assert_response :success
  end

  test "should get edit" do
    get edit_item_environment_url(@item_environment)
    assert_response :success
  end

  test "should update item_environment" do
    patch item_environment_url(@item_environment), params: { item_environment: { active: @item_environment.active, description: @item_environment.description, name: @item_environment.name } }
    assert_redirected_to item_environment_url(@item_environment)
  end

  test "should destroy item_environment" do
    # Delete dependent configuration_items first
    @item_environment.configuration_items.destroy_all

    assert_difference("ItemEnvironment.count", -1) do
      delete item_environment_url(@item_environment)
    end

    assert_redirected_to item_environments_url
  end
end
