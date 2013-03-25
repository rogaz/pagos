class PatientPaymentsController < ApplicationController
  # GET /patient_payments
  # GET /patient_payments.json
  def index
    @patient_payments = PatientPayment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @patient_payments }
    end
  end

  # GET /patient_payments/1
  # GET /patient_payments/1.json
  def show
    @patient_payment = PatientPayment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @patient_payment }
    end
  end

  # GET /patient_payments/new
  # GET /patient_payments/new.json
  def new
    @patient_payment = PatientPayment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @patient_payment }
    end
  end

  # GET /patient_payments/1/edit
  def edit
    @patient_payment = PatientPayment.find(params[:id])
  end

  # POST /patient_payments
  # POST /patient_payments.json
  def create
    @patient_payment = PatientPayment.new(params[:patient_payment])
    @patient_payment.date = Time.now
    patient_paymnet_is_digit = true
    amount_correct = true
    @patient_payments = @patient_payment.patient_charge.patient_payments
    total = 0
    @patient_payments.each do |patient_payment|
      total = total + patient_payment.amount
    end
    @patient_charge = @patient_payment.patient_charge
    por_pagar = @patient_charge.amount - total
    if params[:patient_payment][:amount].to_i == por_pagar
      @patient_charge.liquidated = "si"
      @patient_charge.save
    end
    amount_correct = false if params[:patient_payment][:amount].to_i > por_pagar
    patient_paymnet_is_digit = false if !params[:patient_payment][:amount][/(^[\d]+$)/]

    respond_to do |format|
      if patient_paymnet_is_digit and amount_correct
        @patient_payment.save
        flash[:notice] = "Pago Guardado"
        format.html { redirect_to @patient_payment.patient_charge }
        format.json { render json: @patient_payment.student_charge, status: :created, location: @patient_payment }
      else
        flash[:error] = "La cantidad no debe ser mayor a lo que se debe" if !amount_correct
        flash[:error] = "La cantidad debe ser un numero" if !patient_paymnet_is_digit
        format.html { redirect_to @patient_payment.patient_charge }
        format.json { render json: @patient_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /patient_payments/1
  # PUT /patient_payments/1.json
  def update
    @patient_payment = PatientPayment.find(params[:id])

    respond_to do |format|
      if @patient_payment.update_attributes(params[:patient_payment])
        format.html { redirect_to @patient_payment, notice: 'Patient payment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @patient_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patient_payments/1
  # DELETE /patient_payments/1.json
  def destroy
    @patient_payment = PatientPayment.find(params[:id])
    @patient_charge = @patient_payment.patient_charge
    @patient_charge.liquidated = "no"
    @patient_charge.save
    @patient_payment.destroy

    respond_to do |format|
      format.html { redirect_to @patient_payment.patient_charge }
      format.json { head :no_content }
    end
  end

  def download
    @patient_payment = PatientPayment.find(params[:id])
    send_file @patient_payment.get_path
  end

end
