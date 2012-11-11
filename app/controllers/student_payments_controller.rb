class StudentPaymentsController < ApplicationController
  # GET /student_payments
  # GET /student_payments.json
  def index
    @student_payments = StudentPayment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @student_payments }
    end
  end

  # GET /student_payments/1
  # GET /student_payments/1.json
  def show
    @student_payment = StudentPayment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student_payment }
    end
  end

  # GET /student_payments/new
  # GET /student_payments/new.json
  def new
    @student_payment = StudentPayment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student_payment }
    end
  end

  # GET /student_payments/1/edit
  def edit
    @student_payment = StudentPayment.find(params[:id])
  end

  # POST /student_payments
  # POST /student_payments.json
  def create
    @student_payment = StudentPayment.new(params[:student_payment])

    respond_to do |format|
      if @student_payment.save
        format.html { redirect_to @student_payment, notice: 'Student payment was successfully created.' }
        format.json { render json: @student_payment, status: :created, location: @student_payment }
      else
        format.html { render action: "new" }
        format.json { render json: @student_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /student_payments/1
  # PUT /student_payments/1.json
  def update
    @student_payment = StudentPayment.find(params[:id])

    respond_to do |format|
      if @student_payment.update_attributes(params[:student_payment])
        format.html { redirect_to @student_payment, notice: 'Student payment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_payments/1
  # DELETE /student_payments/1.json
  def destroy
    @student_payment = StudentPayment.find(params[:id])
    @student_payment.destroy

    respond_to do |format|
      format.html { redirect_to student_payments_url }
      format.json { head :no_content }
    end
  end
end
