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

  after_commit :create_eligible_lines, on: :create
  after_commit :calculate_risks, on: :create

  private

  def create_eligible_lines
    @lines = []

    @lines << "vehicle" if insured in { vehicle_year: Integer}
    @lines << "disability" if insured in { income: 1.. }
    @lines << "home" if insured in { house_ownership_status: String }
    @lines << "life" if insured in { age: 0..60 }

    if insured in { age: 61.. }
      @lines.delete "life"
      @lines.delete "disability"
    end

    @lines.each do
      InsuranceLine.create(risk_profile: self, line: _1, risk_level: insured.base_risk)
    end
  end

  def calculate_risks
  end
end
