require "test_helper"

class RiskProfileControllerTest < ActionDispatch::IntegrationTest
  test "should post plan_suggestion" do
    @insured = insureds(:full_eligible)

    post(
      "/risk_profile/plan_suggestion",
      params: {
        insured: {
          age: @insured.age,
          income: @insured.income,
          risk_questions: [0, 1, 1],
          dependents: @insured.dependents,
          house: {ownership_status: @insured.house_ownership_status},
          marital_status: @insured.married?,
          vehicle: {year: @insured.vehicle_year}
        }
      }, as: :json
    )

    assert_response :success

    post(
      "/risk_profile/plan_suggestion",
      params: {
        insured: {
          income: @insured.income,
          risk_questions: [0, 1, 1],
          dependents: @insured.dependents,
          house: {ownership_status: @insured.house_ownership_status},
          marital_status: @insured.married?,
          vehicle: {year: @insured.vehicle_year}
        }
      }, as: :json
    )

    assert_response :unprocessable_entity
  end
end
