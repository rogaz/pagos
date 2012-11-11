class PatientCharge < ActiveRecord::Base
  attr_accessible :amount, :date, :description, :liquidated, :patient_id

  belongs_to :patient
  has_many :patient_payments
  
end
