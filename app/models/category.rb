class Category < ActiveRecord::Base
  attr_accessible :description, :name

  has_many :patients
  has_many :students

  default_scope :order => "categories.id ASC"
end
