require "test_helper"

class ConfigurationItemRelationshipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @configuration_item_relationship = configuration_item_relationships(:one)
  end

  test "should get index" do
    get configuration_item_relationships_url
    assert_response :success
  end

  test "should get new" do
    get new_configuration_item_relationship_url
    assert_response :success
  end

  test "should create configuration_item_relationship" do
    assert_difference("ConfigurationItemRelationship.count") do
      # Create two->one with relationship_type two (fixture has one->two with type one, so no cycle)
      post configuration_item_relationships_url, params: { configuration_item_relationship: { relationship_type_id: relationship_types(:two).id, source_configuration_item_id: configuration_items(:two).id, target_configuration_item_id: configuration_items(:one).id } }
    end

    assert_response :redirect
    assert_match %r{/configuration_item_relationships/[0-9a-f-]+}, @response.location
  end

  test "should show configuration_item_relationship" do
    get configuration_item_relationship_url(@configuration_item_relationship)
    assert_response :success
  end

  test "should get edit" do
    get edit_configuration_item_relationship_url(@configuration_item_relationship)
    assert_response :success
  end

  test "should update configuration_item_relationship" do
    patch configuration_item_relationship_url(@configuration_item_relationship), params: { configuration_item_relationship: { relationship_type_id: @configuration_item_relationship.relationship_type_id, source_configuration_item_id: @configuration_item_relationship.source_configuration_item_id, target_configuration_item_id: @configuration_item_relationship.target_configuration_item_id } }
    assert_redirected_to configuration_item_relationship_url(@configuration_item_relationship)
  end

  test "should destroy configuration_item_relationship" do
    assert_difference("ConfigurationItemRelationship.count", -1) do
      delete configuration_item_relationship_url(@configuration_item_relationship)
    end

    assert_redirected_to configuration_item_relationships_url
  end
end
