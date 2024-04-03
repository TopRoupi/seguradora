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
require "test_helper"

class InsuranceLineTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
