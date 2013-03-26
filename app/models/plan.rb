class Plan < ActiveRecord::Base
  attr_accessible :key, :name

  has_many :students

end
