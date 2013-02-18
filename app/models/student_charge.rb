class StudentCharge < ActiveRecord::Base
  
  after_create :generate_pdf
  after_destroy :destroy_file
  
  attr_accessible :amount, :original_amount, :date, :description, :liquidated, :student_id, :surcharge

  belongs_to :student
  has_many :student_payments, :dependent => :destroy
  default_scope :order => 'student_charges.date DESC'

  def self.will_paginate(student_id, page)
    paginate :per_page => 3, :page => page,
      :conditions => ['student_id = ?', student_id]
  end
  
  @@people_url = "#{Rails.root}/pdfs/people/"
  def generate_pdf
    pdf = Prawn::Document.new
    
    #pdf.stroke_axis
    width = 100
    height = 50
    x = 50
    y = 200
    pdf.stroke_rectangle [x, y], width, height
    pdf.text_box "Monto #{self.amount}", :at => [x + 10, y - 10], :width => width - 20
    
    
    pdf.render_file("#{@@people_url}#{self.student.person.id}/student_charge#{self.id}.pdf")
  end
  
  def destroy_file
    FileUtils.rm "#{@@people_url}#{self.student.person.id}/student_charge#{self.id}.pdf"
  end

end

=begin
# Assignment
pdf = Prawn::Document.new
pdf.text "Hello World"
pdf.render_file "assignment.pdf"
# Implicit Block
Prawn::Document.generate("implicit.pdf") do
text "Hello World"
end
# Explicit Block
Prawn::Document.generate("explicit.pdf") do |pdf|
pdf.text "Hello World"
end


stroke_axis
width = 100
height = 50
x = 50
y = 200
stroke_rectangle [x, y], width, height
text_box "reference rectangle", :at => [x + 10, y - 10], :width => width - 20
scale(2, :origin => [x, y]) do
stroke_rectangle [x, y], width, height
text_box "rectangle scaled from upper-left corner",
:at => [x, y - height - 5], :width => width
end
x = 350
stroke_rectangle [x, y], width, height
text_box "reference rectangle", :at => [x + 10, y - 10], :width => width - 20
scale(2, :origin => [x + width / 2, y - height / 2]) do
stroke_rectangle [x, y], width, height
text_box "rectangle scaled from center",
:at => [x, y - height - 5], :width => width
end



=end
