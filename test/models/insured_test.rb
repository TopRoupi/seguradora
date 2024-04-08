# == Schema Information
#
# Table name: insureds
#
#  id                     :uuid             not null, primary key
#  age                    :integer          not null
#  base_risk              :integer          not null
#  dependents             :integer          not null
#  house_ownership_status :integer
#  income                 :integer          not null
#  married                :boolean          not null
#  vehicle_year           :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require "test_helper"

class InsuredTest < ActiveSupport::TestCase
  setup do
    @insured = insureds(:base)
  end
  # validations
  test "validate age" do
    @insured.age = nil
    @insured.valid?
    refute_empty @insured.errors[:age]
    @insured.age = 0
    @insured.valid?
    assert_empty @insured.errors[:age]
    @insured.age = 20
    @insured.valid?
    assert_empty @insured.errors[:age]
  end

  test "validate income" do
    @insured.income = nil
    @insured.valid?
    refute_empty @insured.errors[:income]
    @insured.income = -1
    @insured.valid?
    refute_empty @insured.errors[:income]
    @insured.income = 0
    @insured.valid?
    assert_empty @insured.errors[:income]
  end

  test "validate dependents" do
    @insured.dependents = nil
    @insured.valid?
    refute_empty @insured.errors[:dependents]
    @insured.dependents = 20
    @insured.valid?
    assert_empty @insured.errors[:dependents]
  end

  test "validate house_ownership_status" do
    @insured.house_ownership_status = nil
    @insured.valid?
    assert_empty @insured.errors[:house_ownership_status]
    @insured.house_ownership_status = :rented
    @insured.valid?
    assert_empty @insured.errors[:house_ownership_status]
  end

  test "validate married" do
    @insured.married = nil
    @insured.valid?
    refute_empty @insured.errors[:married]
    @insured.married = true
    @insured.valid?
    assert_empty @insured.errors[:married]
    @insured.married = false
    @insured.valid?
    assert_empty @insured.errors[:married]
  end

  test "validate base_risk" do
    @insured.base_risk = nil
    @insured.valid?
    refute_empty @insured.errors[:base_risk]
    @insured.base_risk = 0
    @insured.valid?
    assert_empty @insured.errors[:base_risk]
    @insured.age = 3
    @insured.valid?
    assert_empty @insured.errors[:age]
    @insured.base_risk = 4
    @insured.valid?
    refute_empty @insured.errors[:base_risk]
    assert_empty @insured.errors[:age]
    @insured.base_risk = -1
    @insured.valid?
    refute_empty @insured.errors[:base_risk]
  end

  test "validate vehicle_year" do
    @insured.vehicle_year = nil
    @insured.valid?
    assert_empty @insured.errors[:vehicle_year]
    @insured.vehicle_year = -1
    @insured.valid?
    refute_empty @insured.errors[:vehicle_year]
  end

  test "#generate_risk_profile should create a risk profile" do
    assert_difference("@insured.risk_profiles.count", 1) do
      @insured.generate_risk_profile
    end
  end

  test "#calculate_risk should decrease 3 risk levels from all insurance lines if insured age is less 30" do
    insured = insureds(:base)
    insured.age = 29
    profile_risk = insured.generate_risk_profile
    assert profile_risk.insurance_lines.count > 0

    profile_risk.reload
    profile_risk.insurance_lines.each do |i|
      assert_equal i.risk_level, insured.base_risk - 3
    end
  end

  test "#calculate_risk should decrease 1 risk levels from all insurance lines if insured age is 30 or 40" do
    insured = insureds(:base)
    insured.age = 30

    profile_risk = insured.generate_risk_profile
    assert profile_risk.insurance_lines.count > 0

    profile_risk.reload
    profile_risk.insurance_lines.each do |i|
      assert_equal i.risk_level, insured.base_risk - 1
    end

    insured.age = 40
    profile_risk = insured.generate_risk_profile
    profile_risk.reload
    profile_risk.insurance_lines.each do |i|
      assert_equal i.risk_level, insured.base_risk - 1
    end
  end

  test "#calculate_risk should not decrease risk levels if insured age is 41" do
    insured = insureds(:base)
    insured.age = 41

    profile_risk = insured.generate_risk_profile
    assert profile_risk.insurance_lines.count > 0

    profile_risk.insurance_lines.each do |i|
      assert_equal i.risk_level, insured.base_risk
    end
  end

  test "#calculate_risk should decrease 1 risk levels of all insurance lines if insured income is more than 200_000" do
    insured = insureds(:base)
    insured.age = 50
    insured.income = 200_001

    profile_risk = insured.generate_risk_profile
    assert profile_risk.insurance_lines.count > 0

    profile_risk.reload
    profile_risk.insurance_lines.each do |i|
      assert_equal i.risk_level, insured.base_risk - 1
    end

    insured.income = 200_000
    profile_risk = insured.generate_risk_profile
    profile_risk.insurance_lines.each do |i|
      assert_equal i.risk_level, insured.base_risk
    end
  end

  test "#calculate_risk should increase 1 risk level of home and disability if house status is rented" do
    insured = insureds(:base)
    insured.age = 42
    insured.income = 100_000
    insured.house_ownership_status = :rented

    profile_risk = insured.generate_risk_profile

    assert_equal profile_risk.insurance_lines.find_by(line: "home").risk_level, insured.base_risk + 1
    assert_equal profile_risk.insurance_lines.find_by(line: "disability").risk_level, insured.base_risk + 1
    assert_equal profile_risk.insurance_lines.find_by(line: "life").risk_level, insured.base_risk
  end

  test "#calculate_risk should increase 1 risk level to disability and life lines if the insured has dependents" do
    insured = insureds(:base)
    insured.age = 50
    insured.income = 100_000
    insured.house_ownership_status = :owned
    insured.dependents = 2

    profile_risk = insured.generate_risk_profile

    assert_equal profile_risk.insurance_lines.find_by(line: "disability").risk_level, insured.base_risk + 1
    assert_equal profile_risk.insurance_lines.find_by(line: "life").risk_level, insured.base_risk + 1
    assert_equal profile_risk.insurance_lines.find_by(line: "home").risk_level, insured.base_risk
  end

  test "#calculate_risk should increase 1 risk level to life and decrease 1 from disability if the insured is married" do
    insured = insureds(:base)
    insured.age = 50
    insured.income = 100_000
    insured.house_ownership_status = :owned
    insured.married = true

    profile_risk = insured.generate_risk_profile

    assert_equal profile_risk.insurance_lines.find_by(line: "disability").risk_level, insured.base_risk - 1
    assert_equal profile_risk.insurance_lines.find_by(line: "life").risk_level, insured.base_risk + 1
    assert_equal profile_risk.insurance_lines.find_by(line: "home").risk_level, insured.base_risk
  end

  test "#calculate_risk should increase 1 risk level to vehicle if vehicle year is less than current year - 5" do
    insured = insureds(:base)
    insured.age = 50
    insured.vehicle_year = Time.now.year - 5

    profile_risk = insured.generate_risk_profile

    assert_equal profile_risk.insurance_lines.find_by(line: "vehicle").risk_level, insured.base_risk + 1
    assert_equal profile_risk.insurance_lines.find_by(line: "life").risk_level, insured.base_risk

    insured.vehicle_year = Time.now.year - 6

    profile_risk = insured.generate_risk_profile

    assert_equal profile_risk.insurance_lines.find_by(line: "vehicle").risk_level, insured.base_risk
    assert_equal profile_risk.insurance_lines.find_by(line: "life").risk_level, insured.base_risk
  end
end
