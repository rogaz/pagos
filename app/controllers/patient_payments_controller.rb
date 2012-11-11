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

    respond_to do |format|
      if @patient_payment.save
        format.html { redirect_to @patient_payment, notice: 'Patient payment was successfully created.' }
        format.json { render json: @patient_payment, status: :created, location: @patient_payment }
      else
        format.html { render action: "new" }
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
    @patient_payment.destroy

    respond_to do |format|
      format.html { redirect_to patient_payments_url }
      format.json { head :no_content }
    end
  end
end
