class StudentChargesController < ApplicationController
  # GET /student_charges
  # GET /student_charges.json
  def index
    if params[:category_id].nil?
      @student_charges = StudentCharge.all
    else
      @student_charges = Array.new
      @category = Category.find params[:category_id]
      unless @category.students.nil?
        @category.students.each do |student|
          unless student.student_charges.nil?
            student.student_charges.each do |student_charge|
              @student_charges << student_charge
            end
          end
        end
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

  def to_pay
    @category = Category.find params[:category_id]

    @category.students.each do |student|
      @charge_students << student.student_charges
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @student_charges }
    end
  end

end