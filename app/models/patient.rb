class Patient < ActiveRecord::Base
  attr_accessible :category_id, :person_id, :cost

  belongs_to :category
  belongs_to :person
  has_many :patient_charges

  validates :cost, :presence => true

  accepts_nested_attributes_for :person

end
