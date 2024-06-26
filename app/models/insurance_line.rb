# == Schema Information
#
# Table name: insurance_lines
#
#  id              :uuid             not null, primary key
#  line            :string           not null
#  risk_level      :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  risk_profile_id :uuid             not null
#
# Indexes
#
#  index_insurance_lines_on_risk_profile_id  (risk_profile_id)
#
# Foreign Keys
#
#  fk_rails_...  (risk_profile_id => risk_profiles.id)
#
class InsuranceLine < ApplicationRecord
  belongs_to :risk_profile

  validates_presence_of :risk_level, :line

  def recommended_plan
    case risk_level
    in (..0)
      "economy"
    in (1..2)
      "standard"
    in (3..)
      "advanced"
    end
  end
end
