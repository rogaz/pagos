class StudentCharge < ActiveRecord::Base
  attr_accessible :amount, :date, :description, :liquidated, :student_id, :surcharge

  belongs_to :student
  has_many :student_payments, :dependent => :destroy
  default_scope :order => 'student_charges.date DESC'

  def self.will_paginate(student_id, page)
    paginate :per_page => 3, :page => page,
      :conditions => ['student_id = ?', student_id]
  end

end
