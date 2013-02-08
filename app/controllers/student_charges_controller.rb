class StudentChargesController < ApplicationController
  # GET /student_charges
  # GET /student_charges.json
  def index
    if params[:category_id].nil?
      @student_charges_months = StudentCharge.find(:all, :order => "date DESC").group_by { |student_charge| student_charge.date.strftime("%B %Y") }
    else
      student_charges = Array.new
      @category = Category.find params[:category_id]
      unless @category.students.empty?
        @category.students.each do |student|
          unless student.student_charges.empty?
            student.student_charges.each do |student_charge|
              student_charges << student_charge
            end
            @student_charges_months = student_charges.group_by { |student_charge| student_charge.date.strftime("%B %Y") }
          else
            @student_charges_months = Array.new
          end
        end
      else
        @student_charges_months = Array.new
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @student_charges }
    end
  end

  # GET /student_charges/1
  # GET /student_charges/1.json
  def show
    @student_charge = StudentCharge.find(params[:id])
    @student_payments = @student_charge.student_payments
    @student_payment = StudentPayment.new

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student_charge }
    end
  end

  # GET /student_charges/new
  # GET /student_charges/new.json
  def new
    @student_charge = StudentCharge.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student_charge }
    end
  end

  # GET /student_charges/1/edit
  def edit
    @student_charge = StudentCharge.find(params[:id])
  end

  # POST /student_charges
  # POST /student_charges.json
  def create
    @student_charge = StudentCharge.new(params[:student_charge])

    respond_to do |format|
      if @student_charge.save
        format.html { redirect_to @student_charge, notice: 'Student charge was successfully created.' }
        format.json { render json: @student_charge, status: :created, location: @student_charge }
      else
        format.html { render action: "new" }
        format.json { render json: @student_charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /student_charges/1
  # PUT /student_charges/1.json
  def update
    @student_charge = StudentCharge.find(params[:id])

    respond_to do |format|
      if @student_charge.update_attributes(params[:student_charge])
        format.html { redirect_to @student_charge, notice: 'Student charge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student_charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_charges/1
  # DELETE /student_charges/1.json
  def destroy
    @student_charge = StudentCharge.find(params[:id])
    @student_charge.student_payments.empty? ? charge_has_payments = false : charge_has_payments = true

    respond_to do |format|
      if !charge_has_payments
        @student_charge.destroy
        format.html { redirect_to people_charges_url(@student_charge.student.person) }
        format.json { head :no_content }
      else
        flash[:error] = "El cargo tiene pagos"
        format.html { redirect_to people_charges_url(@student_charge.student.person) }
        format.json { head :no_content }
      end
    end
  end

  def pay_student_charge
    unless params[:student_charge_id].nil?
      @student_charge = StudentCharge.find params[:student_charge_id]
      unless @student_charge.liquidated == "si"
        @student_payment = StudentPayment.new
        @student_payment.date = Time.now
        if @student_charge.student_payments.empty?
          @student_payment.amount = @student_charge.amount
        else
          paid = 0
          @student_charge.student_payments.each do |student_charge|
            paid = paid + student_charge.amount
          end
          to_pay = @student_charge.amount - paid
          @student_payment.amount = to_pay
        end
        @student_payment.student_charge_id = @student_charge.id
        @student_payment.save
        @student_charge.liquidated = "si"
        @student_charge.save

        respond_to do |format|
          format.js { render "people/pay_student_charge" }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to people_url }
      end
    end
  end

  def apply_surcharge
    @student_charge = StudentCharge.find params[:student_charge_id]
    if @student_charge.surcharge == false and @student_charge.liquidated == "no"
      @student_charge.surcharge = true
      @student_charge.amount = (@student_charge.amount * 1.10)
      @student_charge.save
      bandera = false
    else
      bandera = true
    end

    respond_to do |format|
      unless bandera
        format.js { render "people/apply_surcharge"}
      else
        flash[:error] = "El estudiante ya tiene recargo de este mes"
        redirect_to people_charges_url(@student_charge.student.person.id)
      end
    end
  end

  def no_apply_surcharge
    @student_charge = StudentCharge.find params[:student_charge_id]
    if @student_charge.surcharge == true and @student_charge.liquidated == "no"
      @student_charge.surcharge = false
      @student_charge.amount = @student_charge.student.cost
      @student_charge.save
      bandera = false
    else
      bandera = true
    end

    respond_to do |format|
      unless bandera
        format.js { render "people/no_apply_surcharge"}
      else
        flash[:error] = "El estudiante no tiene recargo de este mes"
        redirect_to people_charges_url(@student_charge.student.person.id)
      end
    end
  end

end