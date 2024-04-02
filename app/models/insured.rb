# == Schema Information
#
# Table name: insureds
#
#  id                     :uuid             not null, primary key
#  age                    :integer          not null
#  base_risk              :integer          not null
#  dependents             :integer          not null
#  house_ownership_status :integer
#  married                :boolean          not null
#  vehicle_year           :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Insured < ApplicationRecord
  enum :house_ownership_status, [:rented, :owned]

  validates :age, presence: true
  validates :dependents, presence: true
  validates :married, inclusion: [true, false]
  validates :base_risk, presence: true, numericality: {in: 0..3}
  validates :vehicle_year, numericality: {greater_than: 0, allow_nil: true}
end
