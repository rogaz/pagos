class Person < ActiveRecord::Base
  require 'fileutils'
  
  after_create :create_directory
  after_destroy :destroy_directory
  attr_accessible :name

  has_one :student, :dependent => :destroy
  has_one :patient, :dependent => :destroy

  validates :name, :presence => true

  @@people_url = "#{Rails.root}/pdfs/people/"

  def create_directory
    Dir.mkdir "#{@@people_url}#{self.id}"
  end

  def destroy_directory
    FileUtils.rm_rf "#{@@people_url}#{self.id}"
  end

end
