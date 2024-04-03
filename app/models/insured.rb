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
class Insured < ApplicationRecord
  enum :house_ownership_status, [:rented, :owned]

  has_many :risk_profiles, dependent: :destroy

  validates_presence_of :age, :dependents, :base_risk, :income
  validates :married, inclusion: [true, false]
  validates :base_risk, numericality: {in: 0..3}
  validates :vehicle_year, numericality: {greater_than: 0, allow_nil: true}
  validates :income, numericality: {greater_than: -1}

  def generate_risk_profile
    RiskProfile.create(insured: self)
  end

  def deconstruct_keys(keys)
    attributes.symbolize_keys
  end
end
