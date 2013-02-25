class Patient < ActiveRecord::Base
  attr_accessible :category_id, :person_id, :cost

  after_create :create_directory
  after_destroy :destroy_directory

  belongs_to :category
  belongs_to :person
  has_many :patient_charges

  validates :cost, :presence => true

  accepts_nested_attributes_for :person

  @@people_url = "#{Rails.root}/pdfs/people/"

  def create_directory
    Dir.mkdir "#{@@people_url}#{self.person.id}/patient_charges/"
  end

  def destroy_directory
    FileUtils.rm_rf "#{@@people_url}#{self.person.id}/patient_charges/"
  end

end
