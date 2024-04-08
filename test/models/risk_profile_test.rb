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

  test "should have vehicle insurance if vehicle_year is set" do
    @insured.vehicle_year = 2001
    profile = @insured.generate_risk_profile
    assert_equal profile.insurance_lines.where(line: "vehicle").count, 1
    assert_equal profile.insurance_lines.count, 1
  end

  test "should have disability insurance if income is more than 0" do
    @insured.income = 110_000
    @insured.age = 40
    profile = @insured.generate_risk_profile
    assert_equal profile.insurance_lines.where(line: "disability").count, 1
  end

  test "should have home insurance if house_ownership_status is set" do
    @insured.house_ownership_status = :rented
    profile = @insured.generate_risk_profile
    assert_equal profile.insurance_lines.where(line: "home").count, 1
    assert_equal profile.insurance_lines.count, 1
  end

  test "should have life insurance if age is less than 61" do
    @insured.age = 60
    profile = @insured.generate_risk_profile
    assert_equal profile.insurance_lines.where(line: "life").count, 1
    assert_equal profile.insurance_lines.count, 1
  end

  test "should not have life insurance if age is more than 60" do
    @insured.age = 61
    profile = @insured.generate_risk_profile
    assert_equal profile.insurance_lines.where(line: "life").count, 0
    assert_equal profile.insurance_lines.count, 0
  end

  test "should not have disability insurance if age is more than 60" do
    @insured.age = 61
    # yes we should deny this person insurence
    @insured.income = 99_999_999
    profile = @insured.generate_risk_profile
    assert_equal profile.insurance_lines.where(line: "disability").count, 0
  end

  test "should be able to have multiple insurances" do
    @insured.age = 40
    @insured.income = 99_999_999
    @insured.vehicle_year = 2000
    @insured.house_ownership_status = :rented
    profile = @insured.generate_risk_profile
    assert_equal profile.insurance_lines.count, 4
  end

  test "#suggested_plans" do
    @insured = insureds(:full_eligible)
    @insured.vehicle_year = nil
    profile = @insured.generate_risk_profile

    profile.reload
    assert_equal(
      [
        {"vehicle" => "ineligible"},
        {"life" => "advanced"},
        {"home" => "standard"},
        {"disability" => "standard"}
      ],
      profile.suggested_plans
    )
  end
end
