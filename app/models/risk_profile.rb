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
  after_commit :create_eligible_lines, on: :create
  after_commit :calculate_risks, on: :create

  private

  # TODO: maybe make a new class for each insurance line then
  # call a method named like "evaluate_eligibility" to each one
  # of them
  def set_eligible_lines
    @lines = []

    @lines << "vehicle" if insured in { vehicle_year: Integer}
    @lines << "disability" if insured in { income: 1.. }
    @lines << "home" if insured in { house_ownership_status: String }
    @lines << "life" if insured in { age: 0..60 }
    if insured in { age: 61.. }
      @lines.delete "life"
      @lines.delete "disability"
    end
  end
  def create_eligible_lines
    @lines.each do
      InsuranceLine.create(risk_profile: self, line: _1, risk_level: insured.base_risk)
    end
  end

  # this method is not "atomic" if you call it more than one
  # it will add more risk to the insurance lines even tough
  # the risk was already calculated before TODO: fix it
  ## TODO: the same problem with #set_eligible_lines also applys here
  def calculate_risks
    increment_risk(insurance_lines, -3) if insured.age < 30
    increment_risk(insurance_lines, -1) if insured.age >= 30 && insured.age <= 40
    increment_risk(insurance_lines, -1) if insured.income > 200_000
    if insured.rented?
      increment_risk([insurance_lines.find_by(line: "home"), insurance_lines.find_by(line: "disability")], 1)
    end
    if insured.dependents > 0
      increment_risk([insurance_lines.find_by(line: "life"), insurance_lines.find_by(line: "disability")], 1)
    end
    if insured.married?
      increment_risk([insurance_lines.find_by(line: "life"), insurance_lines.find_by(line: "disability")], 1)
    end

    if insured.vehicle_year && insured.vehicle_year >= (Time.now.year - 5)
      increment_risk([insurance_lines.find_by(line: "vehicle")], 1)
    end
  end

  def increment_risk(insurance_lines, by)
    # TODO: this may generate a bunch of sql queries
    # refactor later
    insurance_lines.each do |i|
      next if i.nil?
      i.risk_level += by
      i.save
    end
  end
end
