require "test_helper"

class ItemTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item_type = item_types(:one)
  end

  test "should get index" do
    get item_types_url
    assert_response :success
  end

  test "should get new" do
    get new_item_type_url
    assert_response :success
  end

  test "should create item_type" do
    assert_difference("ItemType.count") do
      post item_types_url, params: { item_type: { active: @item_type.active, description: @item_type.description, name: "Database" } }
    end

    assert_response :redirect
    assert_match %r{/item_types/[0-9a-f-]+}, @response.location
  end

  test "should show item_type" do
    get item_type_url(@item_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_item_type_url(@item_type)
    assert_response :success
  end

  test "should update item_type" do
    patch item_type_url(@item_type), params: { item_type: { active: @item_type.active, description: @item_type.description, name: @item_type.name } }
    assert_redirected_to item_type_url(@item_type)
  end

  test "should destroy item_type" do
    # Delete dependent configuration_items first
    @item_type.configuration_items.destroy_all

    assert_difference("ItemType.count", -1) do
      delete item_type_url(@item_type)
    end

    assert_redirected_to item_types_url
  end
end
