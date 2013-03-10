class AddSessionDateToPatientCharges < ActiveRecord::Migration
  def change
    add_column :patient_charges, :session_date, :date
  end
end
