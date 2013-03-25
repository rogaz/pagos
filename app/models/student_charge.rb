class StudentCharge < ActiveRecord::Base
  
  attr_accessible :amount, :original_amount, :date, :description, :liquidated, :student_id, :surcharge

  belongs_to :student
  has_many :student_payments, :dependent => :destroy
  default_scope :order => 'student_charges.date DESC'

  after_create :generate_pdf
  after_destroy :destroy_file

  def self.will_paginate(student_id, page)
    paginate :per_page => 3, :page => page,
      :conditions => ['student_id = ?', student_id]
  end
  
  @@people_url = "#{Rails.root}/pdfs/people/"
  
  def get_path
    directory_date = "#{self.date.strftime('%d-%m-%y')}-#{self.id}"
    @@people_url + self.student.person.id.to_s + "/student_charges/#{directory_date}/cargo_colegiatura_#{self.id.to_s}.pdf"
  end
  
  def generate_pdf
    directory_date = "#{self.date.strftime('%d-%m-%y')}-#{self.id}"
    Dir.mkdir "#{@@people_url}#{self.student.person.id}/student_charges/#{directory_date}"
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
    pdf.render_file("#{@@people_url}#{self.student.person.id}/student_charges/#{directory_date}/cargo_colegiatura_#{self.id}.pdf")
  end
  
  def destroy_file
    directory_date = "#{self.date.strftime('%d-%m-%y')}-#{self.id}"
    FileUtils.rm_rf "#{@@people_url}#{self.student.person.id}/student_charges/#{directory_date}"
  end

end
