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
require "test_helper"

class RiskProfileTest < ActiveSupport::TestCase
  setup do
    @insured = insureds(:base)
  end

  test "should have no insurance lines if not eligible to any" do
    profile = @insured.generate_risk_profile
    assert_equal profile.insurance_lines.size, 0
  end

  test "should have no vehicle insurance if eligible" do
    @insured.vehicle_year = 2001
    profile = @insured.generate_risk_profile
    assert_equal profile.insurance_lines.where(line: "vehicle").count, 1
    assert_equal profile.insurance_lines.count, 1
  end
end
