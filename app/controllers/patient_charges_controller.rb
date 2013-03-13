class PatientChargesController < ApplicationController
  # GET /patient_charges
  # GET /patient_charges.json
  def index
    if params[:category_id].nil?
      #@patient_charges = PatientCharge.find(:all)
      @patient_charges_months = PatientCharge.find(:all, :order => "date DESC").group_by { |patient_charge| patient_charge.date.strftime("%B %Y") }
    else
      #patient_charges = Array.new
      @category = Category.find params[:category_id]
      @patient_charges_months = PatientCharge.find(:all, :order => "date DESC").group_by { |patient_charge| patient_charge.date.strftime("%B %Y") }
=begin
      unless @category.patients.empty?
        @category.patients.each do |patient|
          unless patient.patient_charges.empty?
            patient.patient_charges.each do |patient_charge|
              patient_charges << patient_charge
            end
            @patient_charges_months = patient_charges.group_by { |patient_charge| patient_charge.date.strftime("%B %Y") }
          else
            @patient_charges_months = Array.new
          end
        end
      else
        @patient_charges_months = Array.new
      end
=end
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @patient_charges }
    end
  end

  # GET /patient_charges/1
  # GET /patient_charges/1.json
  def show
    @patient_charge = PatientCharge.find(params[:id])
    @patient_payments = @patient_charge.patient_payments
    @patient_payment = PatientPayment.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @patient_charge }
    end
  end

  # GET /patient_charges/new
  # GET /patient_charges/new.json
  def new
    @patient_charge = PatientCharge.new
    @patient = Patient.find params[:patient_id] unless params[:patient_id].nil?
    @horarios = Array.new
    i = 0
    while i < 13
      if i < 3
      @horarios << "#{i+8}:00 a.m. - #{i+9}:00 a.m."
      elsif i == 4
        @horarios << "#{i+8}:00 a.m. - #{i-3}:00 p.m."
      elsif i > 4
        @horarios << "#{i-4}:00 p.m. - #{i-3}:00 p.m."
      end
      i += 1
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @patient_charge }
    end
  end

  # GET /patient_charges/1/edit
  def edit
    @patient_charge = PatientCharge.find(params[:id])
    @patient = @patient_charge.patient
    @horarios = Array.new
    i = 0
    while i < 13
      if i < 3
      @horarios << "#{i+8}:00 a.m. - #{i+9}:00 a.m."
      elsif i == 4
        @horarios << "#{i+8}:00 a.m. - #{i-3}:00 p.m."
      elsif i > 4
        @horarios << "#{i-4}:00 p.m. - #{i-3}:00 p.m."
      end
      i += 1
    end
  end

  # POST /patient_charges
  # POST /patient_charges.json
  def create
    @patient_charge = PatientCharge.new(params[:patient_charge])
    @patient = Patient.find params[:patient_charge][:patient_id]
    @patient_charge.amount = @patient.cost
    @patient_charge.liquidated = "no"
    @patient_charge.date = Time.now
    @patient_charge.patient_id = @patient.id

    respond_to do |format|
      if @patient_charge.save
        format.html { redirect_to people_charges_path(@patient_charge.patient.person), notice: 'Cargo de Sesion Guardado Correctamente' }
        format.json { render json: @patient_charge, status: :created, location: @patient_charge }
      else
        format.html { redirect_to people_charges_path(@patient_charge.patient.person), notice: 'No se guardo cargo!' }
        format.json { render json: @patient_charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /patient_charges/1
  # PUT /patient_charges/1.json
  def update
    @patient_charge = PatientCharge.find(params[:id])

    respond_to do |format|
      if @patient_charge.update_attributes(params[:patient_charge])
        format.html { redirect_to @patient_charge, notice: 'Patient charge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @patient_charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patient_charges/1
  # DELETE /patient_charges/1.json
  def destroy
    @patient_charge = PatientCharge.find(params[:id])
    @patient_charge.patient_payments.empty? ? charge_has_payments = false : charge_has_payments = true
    
    respond_to do |format|
      if !charge_has_payments
        @patient_charge.destroy
        format.html { redirect_to people_charges_url(@patient_charge.patient.person) }
        format.json { head :no_content }
      else
        flash[:error] = "El cargo tiene pagos"
        format.html { redirect_to people_charges_url(@patient_charge.patient.person) }
        format.json { head :no_content }
      end
    end
  end

  def pay_patient_charge
    unless params[:patient_charge_id].nil?
      @patient_charge = PatientCharge.find params[:patient_charge_id]
      @patient_payment = PatientPayment.new
      @patient_payment.date = Time.now
      if @patient_charge.patient_payments.empty?
        @patient_payment.amount = @patient_charge.amount
      else
        paid = 0
        @patient_charge.patient_payments.each do |patient_charge|
          paid = paid + patient_charge.amount
        end
        to_pay = @patient_charge.amount - paid
        @patient_payment.amount = to_pay
      end
      @patient_payment.patient_charge_id = @patient_charge.id
      @patient_payment.save
      @patient_charge.liquidated = "si"
      @patient_charge.save

      respond_to do |format|
        format.js { render "people/pay_patient_charge" }
      end
    else
      redirect_to people_charges_url
    end
  end

  def download
    @patient_charge = PatientCharge.find params[:id]
    send_file @patient_charge.get_path
  end

end
