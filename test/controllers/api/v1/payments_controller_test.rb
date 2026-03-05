require "test_helper"

class Api::V1::PaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_payments_index_url
    assert_response :success
  end

  test "should get show" do
    get api_v1_payments_show_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_payments_create_url
    assert_response :success
  end

  test "should get update" do
    get api_v1_payments_update_url
    assert_response :success
  end

  test "should get destroy" do
    get api_v1_payments_destroy_url
    assert_response :success
  end
end
