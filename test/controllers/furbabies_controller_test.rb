require "test_helper"

class FurbabiesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get furbabies_new_url
    assert_response :success
  end

  test "should get create" do
    get furbabies_create_url
    assert_response :success
  end

  test "should get show" do
    get furbabies_show_url
    assert_response :success
  end

  test "should get update" do
    get furbabies_update_url
    assert_response :success
  end

  test "should get index" do
    get furbabies_index_url
    assert_response :success
  end
end
