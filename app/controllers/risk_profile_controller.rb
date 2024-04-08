class RiskProfileController < ApplicationController
  def plan_suggestion
    insured = Insured.new(insured_params)

    if insured.save
      render json: insured.generate_risk_profile.suggested_plans
    else
      render json: insured.errors, status: :unprocessable_entity
    end
  end

  private

  def insured_params
    r = params.require(:insured).permit(
      :age,
      :dependents,
      :income,
      {house: :ownership_status},
      :marital_status,
      {risk_questions: []},
      {vehicle: :year}
    )
    # TODO: using rightward assignment here might be more
    # readable
    r[:house_ownership_status] = r[:house]&.[]("ownership_status")
    r[:married] = r[:marital_status] == "married"
    r[:base_risk] = r[:risk_questions].sum
    r[:vehicle_year] = r[:vehicle]&.[]("year")

    r.delete :house
    r.delete :marital_status
    r.delete :risk_questions
    r.delete :vehicle
    r
  end
end
