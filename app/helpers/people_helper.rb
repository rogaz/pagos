module PeopleHelper

  def saldo_general_por_pagar(person)
    saldo_general_por_pagar = 0
    unless person.student.nil?
      student = person.student
      student_charges = student.student_charges
      student_charges.each do |student_charge|
        unless student_charge.student_payments.empty?
          paid = 0
          student_charge.student_payments.each do |student_payment|
            paid += student_payment.amount
          end
          saldo_general_por_pagar += student_charge.amount - paid
        else
          saldo_general_por_pagar += student_charge.amount
        end
      end
    end
    unless person.patient.nil?
      patient = person.patient
      patient_charges = patient.patient_charges
      patient_charges.each do |patient_charge|
        unless patient_charge.patient_payments.empty?
          paid = 0
          patient_charge.patient_payments.each do |patient_payment|
            paid += patient_payment.amount
          end
          saldo_general_por_pagar += patient_charge.amount - paid
        else
          saldo_general_por_pagar += patient_charge.amount
        end
      end
    end
    return saldo_general_por_pagar
  end

end
