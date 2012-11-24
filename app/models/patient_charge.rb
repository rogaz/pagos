class PatientCharge < ActiveRecord::Base
  attr_accessible :amount, :date, :description, :liquidated, :patient_id

  belongs_to :patient
  has_many :patient_payments, :dependent => :destroy
  default_scope :order => 'patient_charges.date DESC'

  def self.will_paginate(patient_id, page)
    paginate :per_page => 5, :page => page,
      :conditions => ['patient_id = ?', patient_id]
  end
end
