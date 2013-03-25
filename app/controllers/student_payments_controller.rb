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
    @student_payment.date = Time.now
    student_paymnet_is_digit = true
    amount_correct = true
    @student_payments = @student_payment.student_charge.student_payments
    total = 0
    @student_payments.each do |student_payment|
      total = total + student_payment.amount
    end
    @student_charge = @student_payment.student_charge
    por_pagar = @student_charge.amount - total
    if params[:student_payment][:amount].to_i == por_pagar
      @student_charge.liquidated = "si"
      @student_charge.save
    end
    amount_correct = false if params[:student_payment][:amount].to_i > por_pagar
    student_paymnet_is_digit = false if !params[:student_payment][:amount][/(^[\d]+$)/]

    respond_to do |format|
      if student_paymnet_is_digit and amount_correct
        @student_payment.save
        flash[:notice] = "Pago Guardado"
        format.html { redirect_to @student_payment.student_charge }
        format.json { render json: @student_payment.student_charge, status: :created, location: @student_payment }
      else
        flash[:error] = "La cantidad no debe ser mayor a lo que se debe" if !amount_correct
        flash[:error] = "La cantidad debe ser un numero" if !student_paymnet_is_digit
        format.html { redirect_to @student_payment.student_charge }
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
    @student_charge = @student_payment.student_charge
    @student_charge.liquidated = "no"
    @student_charge.save
    @student_payment.destroy


    respond_to do |format|
      format.html { redirect_to @student_payment.student_charge }
      format.json { head :no_content }
    end
  end

  def download
    @student_payment = StudentPayment.find params[:id]
    send_file @student_payment.get_path
  end

end
