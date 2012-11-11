class PatientPayment < ActiveRecord::Base
  attr_accessible :amount, :date, :patient_charge_id

  belongs_to :patient_charge
end
