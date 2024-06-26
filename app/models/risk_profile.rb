# == Schema Information
#
# Table name: risk_profiles
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  insured_id :uuid             not null
#
# Indexes
#
#  index_risk_profiles_on_insured_id  (insured_id)
#
# Foreign Keys
#
#  fk_rails_...  (insured_id => insureds.id)
#
class RiskProfile < ApplicationRecord
  belongs_to :insured
  has_many :insurance_lines, dependent: :destroy

  after_commit :set_eligible_lines, on: :create
  after_commit :calculate_risks, on: :create

  PROVIDED_PLANS = ["vehicle", "life", "home", "disability"]

  def suggested_plans
    lines = insurance_lines.to_a

    PROVIDED_PLANS.map do |line|
      recommended_plan = lines.find { _1.line == line }&.recommended_plan
      recommended_plan ||= "ineligible"
      {line => recommended_plan}
    end
  end

  private

  # TODO this method creates the insurance lines one by one
  # and generates a lot of queries
  def set_eligible_lines
    PROVIDED_PLANS.each do |line|
      line_instance = LinesFactory.new_instance(line, insured)

      if line_instance.eligible?
        InsuranceLine.create(
          risk_profile: self,
          line: line,
          risk_level: insured.base_risk
        )
      end
    end
  end

  # this method is not "idempotence" if you call it more than one
  # it will add more risk to the insurance lines even tough
  # the risk was already calculated before TODO: fix it
  #
  # TODO: the same problem with #set_eligible_lines also applys here
  def calculate_risks
    increment_risk(PROVIDED_PLANS, -3) if insured.age < 30
    increment_risk(PROVIDED_PLANS, -1) if insured.age >= 30 && insured.age <= 40
    increment_risk(PROVIDED_PLANS, -1) if insured.income > 200_000
    increment_risk(["home", "disability"], 1) if insured.rented?
    increment_risk(["life", "disability"], 1) if insured.dependents > 0

    if insured.married?
      increment_risk(["life"], 1)
      increment_risk(["disability"], -1)
    end

    if insured.vehicle_year && insured.vehicle_year >= (Time.now.year - 5)
      increment_risk(["vehicle"], 1)
    end
  end

  def increment_risk(lines, by)
    InsuranceLine.where({line: lines}).update_all(["risk_level = risk_level + ?", by])
  end
end
