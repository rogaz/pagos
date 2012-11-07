class StudentCharge < ActiveRecord::Base
  attr_accessible :amount, :date, :description, :liquidated, :student_id, :surcharge

  belongs_to :student
end
