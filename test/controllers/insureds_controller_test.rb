require "test_helper"

class InsuredsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @insured = insureds(:one)
  end

  test "should get index" do
    get insureds_url, as: :json
    assert_response :success
  end

  test "should create insured" do
    assert_difference("Insured.count") do
      post insureds_url, params: {insured: {age: @insured.age, base_risk: @insured.base_risk, dependents: @insured.dependents, house_ownership_status: @insured.house_ownership_status, married: @insured.married, vehicle_year: @insured.vehicle_year}}, as: :json
    end

    assert_response :created
  end

  test "should show insured" do
    get insured_url(@insured), as: :json
    assert_response :success
  end

  test "should update insured" do
    patch insured_url(@insured), params: {insured: {age: @insured.age, base_risk: @insured.base_risk, dependents: @insured.dependents, house_ownership_status: @insured.house_ownership_status, married: @insured.married, vehicle_year: @insured.vehicle_year}}, as: :json
    assert_response :success
  end

  test "should destroy insured" do
    assert_difference("Insured.count", -1) do
      delete insured_url(@insured), as: :json
    end

    assert_response :no_content
  end
end
