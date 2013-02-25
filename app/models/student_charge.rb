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
  
  def get_path
    return @@people_url + self.student.person.id.to_s + "/student_charges/student_charge" + self.id.to_s + ".pdf"
  end
  
  def generate_pdf
    pdf = Prawn::Document.new
    pdf.font_size(25)
    pdf.text "Centro a Atencion a las Alteraciones del Aprendizaje y la Comunicacion S.C.", :align => :center
    pdf.font_size(18)
    pdf.move_down 10
    pdf.image "pdfs/cenaac.jpg", :position => :center
    pdf.move_down 30
    pdf.text self.student.person.name, :align => :center
    width = 160
    height = 20
    x = 120
    y = 450
    pdf.font_size(14)
    pdf.stroke_rectangle([x-5 ,y+5], width*2, height*3)
    pdf.text_box "Concepto", :at => [x, y], :width => width, :height => height
    pdf.text_box "Cargo de Colegiatura", :at => [x+width, y], :width => width, :height => height
    pdf.line([x-5, y-height+5], [x+(width*2)-5, y-height+5])
    pdf.stroke
    pdf.text_box "Cantidad", :at => [x, y-height], :width => width, :height => height
    pdf.text_box "$#{self.amount}.00", :at => [x+width, y-height], :width => width, :height => height
    pdf.line([x-5, y-(height*2)+5], [x+(width*2)-5, y-(height*2)+5])
    pdf.stroke
    pdf.text_box "Fecha", :at => [x, y-(height*2)], :width => width, :height => height
    pdf.text_box self.date.strftime("%d %b %Y"), :at => [x+width, y-(height*2)], :width => width, :height => height
#    data = [["Cantidad", "$#{self.amount}.00"]]
#    data += [["Fecha", self.date.strftime("%d %b %Y")]]
#    pdf.table data, :row_colors => ["F0F0F0", "FFFFCC"]
    pdf.render_file("#{@@people_url}#{self.student.person.id}/student_charges/student_charge#{self.id}.pdf")
  end
  
  def destroy_file
    FileUtils.rm "#{@@people_url}#{self.student.person.id}/student_charges/student_charge#{self.id}.pdf"
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
