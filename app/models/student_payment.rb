class StudentPayment < ActiveRecord::Base
  attr_accessible :amount, :date, :student_charge_id

  belongs_to :student_charge

  after_create :generate_pdf
  after_destroy :destroy_file

  @@people_url = "#{Rails.root}/pdfs/people/"
  # TODO: Si se elimina un pago, los demas archivos no serán válidos
  def get_path
    directory_date = "#{self.date.strftime('%d-%m-%y')}-#{self.student_charge.id}"
    @@people_url + self.student_charge.student.person.id.to_s + "/student_charges/#{directory_date}/pago_#{self.id.to_s}.pdf"
  end

  def generate_pdf
    directory_date = "#{self.date.strftime('%d-%m-%y')}-#{self.student_charge.id}"
    pdf = Prawn::Document.new
    pdf.font_size(25)
    pdf.text "Centro a Atencion a las Alteraciones del Aprendizaje y la Comunicacion S.C.", :align => :center
    pdf.font_size(18)
    pdf.move_down 10
    pdf.image 'pdfs/cenaac.jpg', :position => :center
    pdf.move_down 30
    pdf.text self.student_charge.student.person.name, :align => :center
    width = 160
    height = 20
    x = 40
    y = 450
    pdf.font_size(14)
    pdf.font 'Helvetica', :style => :bold
    pdf.text_box self.student_charge.description, :at => [x, y], :width => width, :height => height
    pdf.text_box "$#{self.student_charge.amount.to_s}.00", :at => [x+width, y], :width => width, :height => height
    pdf.text_box self.student_charge.date.strftime('%d %b %Y'), :at => [x+(width*2), y], :width => width, :height => height
    pdf.line([x-5, y-height+5], [x+(width*3)-5, y-height+5])
    pdf.stroke
    pdf.font 'Helvetica', :style => :normal
    self.student_charge.student_payments.each_with_index do |student_payment, index|
      pdf.text_box '-', :at => [x+width-20, y-((height)*(index+1))], :width => width, :height => height
      pdf.text_box "$#{student_payment.amount.to_s}.00", :at => [x+width, y-((height)*(index+1))], :width => width, :height => height
      pdf.text_box student_payment.date.strftime('%d %b %Y'), :at => [x+(width*2), y-((height)*(index+1))], :width => width, :height => height
    end
    pdf.font 'Helvetica', :style => :bold
    pdf.text_box '-', :at => [x+width-20, y-((height)*(self.student_charge.student_payments.count))], :width => width, :height => height
    pdf.text_box "$#{self.amount.to_s}.00", :at => [x+width, y-((height)*(self.student_charge.student_payments.count))], :width => width, :height => height
    pdf.text_box self.date.strftime('%d %b %Y'), :at => [x+(width*2), y-((height)*(self.student_charge.student_payments.count))], :width => width, :height => height
    pdf.line([x-5, y-height+5-((height)*(self.student_charge.student_payments.count))], [x+(width*3)-5, y-height+5-((height)*(self.student_charge.student_payments.count))])
    pdf.stroke
    payed = 0
    self.student_charge.student_payments.each do |student_payment|
      payed += student_payment.amount
    end
    total = 0
    total = self.student_charge.amount - payed
    total -= self.amount
    pdf.text_box 'Adeudo', :at => [x+width-50, y-((height)*(self.student_charge.student_payments.count+1))], :width => width, :height => height
    pdf.text_box "#{total}.00", :at => [x+width, y-((height)*(self.student_charge.student_payments.count+1))], :width => width, :height => height
    pdf.text_box self.date.strftime('%d %b %Y'), :at => [x+(width*2), y-((height)*(self.student_charge.student_payments.count+1))], :width => width, :height => height
    pdf.render_file("#{@@people_url}#{self.student_charge.student.person.id}/student_charges/#{directory_date}/pago_#{self.id}.pdf")
  end

  def destroy_file
    directory_date = "#{self.date.strftime('%d-%m-%y')}-#{self.student_charge.id}"
    FileUtils.rm "#{@@people_url}#{self.student_charge.student.person.id}/student_charges/#{directory_date}/pago_#{self.id}.pdf"
  end

end
