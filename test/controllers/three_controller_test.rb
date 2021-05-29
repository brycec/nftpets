require "test_helper"

class ThreeControllerTest < ActionDispatch::IntegrationTest
  test "should get module" do
    get three_module_url
    assert_response :success
  end
end
