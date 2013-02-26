class PatientCharge < ActiveRecord::Base
  attr_accessible :amount, :date, :description, :liquidated, :patient_id

  after_create :generate_pdf
  after_destroy :destroy_file

  belongs_to :patient
  has_many :patient_payments, :dependent => :destroy
  default_scope :order => 'patient_charges.date DESC'

  def self.will_paginate(patient_id, page)
    paginate :per_page => 5, :page => page,
      :conditions => ['patient_id = ?', patient_id]
  end

  @@people_url = "#{Rails.root}/pdfs/people/"

  def get_path
    directory_date = "#{self.date.day}-#{self.date.month}-#{self.date.year}-#{self.id}"
    return @@people_url + self.patient.person.id.to_s + "/patient_charges/#{directory_date}/cargo_sesion_#{self.id.to_s}.pdf"
  end

  def generate_pdf
    directory_date = "#{self.date.day}-#{self.date.month}-#{self.date.year}-#{self.id}"
    Dir.mkdir "#{@@people_url}#{self.patient.person.id}/patient_charges/#{directory_date}"
    pdf = Prawn::Document.new
    pdf.font_size(25)
    pdf.text "Centro a Atencion a las Alteraciones del Aprendizaje y la Comunicacion S.C.", :align => :center
    pdf.font_size(18)
    pdf.move_down 10
    pdf.image "pdfs/cenaac.jpg", :position => :center
    pdf.move_down 30
    pdf.text self.patient.person.name, :align => :center
    width = 140
    height = 20
    x = 120
    y = 450
    pdf.font_size(14)
    pdf.stroke_rectangle([x-5 ,y+5], width*2, height*3)
    pdf.text_box "Concepto", :at => [x, y], :width => width, :height => height
    pdf.text_box "Cargo de Sesion", :at => [x+width, y], :width => width, :height => height
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
    pdf.render_file("#{@@people_url}#{self.patient.person.id}/patient_charges/#{directory_date}/cargo_sesion_#{self.id}.pdf")
  end

  def destroy_file
    directory_date = "#{self.date.day}-#{self.date.month}-#{self.date.year}-#{self.id}"
    FileUtils.rm "#{@@people_url}#{self.patient.person.id}/patient_charges/#{directory_date}/cargo_sesion_#{self.id}.pdf"
  end

end
