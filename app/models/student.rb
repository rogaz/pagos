class Student < ActiveRecord::Base
  attr_accessible :category_id, :person_id, :cost, :plan_id

  after_create :create_directory, :colegiatura_proporcional
  after_destroy :destroy_directory

  belongs_to :category
  belongs_to :person
  belongs_to :plan
  has_many :student_charges

  validates :category_id, :presence => true
  validates :person_id, :presence => true
  validates :cost, :presence => true

  accepts_nested_attributes_for :person

  def colegiatura_proporcional
    fecha_actual = Time.now
    if fecha_actual.day < 30
      @student_charge = StudentCharge.new
      proporcional = (self.cost/30.to_f) * (30-fecha_actual.day)
      @student_charge.amount = proporcional
      @student_charge.original_amount = proporcional
      @student_charge.liquidated = "no"
      @student_charge.description = "Proporcional de Colegiatura #{Time.now.month} #{Time.now.year}"
      @student_charge.date = Time.now
      @student_charge.student_id = self.id
      @student_charge.surcharge = false
      @student_charge.save
    end
  end

  @@people_url = "#{Rails.root}/pdfs/people/"

  def create_directory
    Dir.mkdir "#{@@people_url}#{self.person.id}/student_charges/"
  end

  def destroy_directory
    FileUtils.rm_rf "#{@@people_url}#{self.person.id}/student_charges/"
  end

end
