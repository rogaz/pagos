class CreatePatientPayments < ActiveRecord::Migration
  def change
    create_table :patient_payments do |t|
      t.integer :amount
      t.datetime :date
      t.integer :patient_charge_id

      t.timestamps
    end
  end
end
