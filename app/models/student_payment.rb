class StudentPayment < ActiveRecord::Base
  attr_accessible :amount, :date, :student_charge_id

  belongs_to :student_charge_id
end
