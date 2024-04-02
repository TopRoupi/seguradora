class CreateInsureds < ActiveRecord::Migration[7.1]
  def change
    create_table :insureds, id: :uuid do |t|
      t.integer :age, null: false
      t.integer :dependents, null: false
      t.integer :house_ownership_status
      t.boolean :married, null: false
      t.integer :base_risk, null: false
      t.integer :vehicle_year

      t.timestamps
    end
  end
end
