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
  setup do
    @line = insurance_lines(:vehicle)
  end
  # validations
  test "validate risk_level" do
    @line.risk_level = nil
    @line.valid?
    refute_empty @line.errors[:risk_level]
    @line.risk_level = -1
    @line.valid?
    refute_empty @line.errors[:risk_level]
    @line.risk_level = 0
    @line.valid?
    assert_empty @line.errors[:risk_level]
  end

  test "validate line" do
    @line.line = nil
    @line.valid?
    refute_empty @line.errors[:line]
    @line.line = "life"
    @line.valid?
    assert_empty @line.errors[:line]
  end
end
