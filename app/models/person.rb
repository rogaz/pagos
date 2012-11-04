class Person < ActiveRecord::Base
  attr_accessible :name

  has_one :student, :dependent => :destroy
  has_one :patient, :dependent => :destroy

  validates :name, :presence => true

end
